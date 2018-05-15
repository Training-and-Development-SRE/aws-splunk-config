terraform {
  required_version = ">= 0.9.2"
}

# Create the dead letter queue and assign this queue to all queues
resource "aws_sqs_queue" "terraform_queue_deadletter" {
  name = "splunk-queue-deadletter"
  visibility_timeout_seconds = 300
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 0

  tags = "${merge(
    local.common_tags
  )}"
}

# Create a queue for each S3 bucket
resource "aws_sqs_queue" "splunk_config_queue" {
  name                      = "${var.splunk-prefix}-${var.s3-splunk-buckets}"
  visibility_timeout_seconds = 300
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 0
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.terraform_queue_deadletter.arn}\",\"maxReceiveCount\":4}"

  tags = "${merge(
    local.common_tags
  )}"
}

resource "aws_sqs_queue_policy" "test" {
  queue_url = "${aws_sqs_queue.splunk_config_queue.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.splunk.arn}"
      },
      "Action": "sqs:ReceiveMessage",
      "Resource": "${aws_sqs_queue.splunk_config_queue.arn}"
    }
  ]
}
POLICY
}

# Topic assigned to each s3 bucket
resource "aws_sns_topic" "splunk_config_topic" {
  name = "${var.splunk-prefix}-${var.s3-splunk-buckets}"
}

# Assign the policy to the topic
resource "aws_sns_topic_policy" "default" {
  arn = "${aws_sns_topic.splunk_config_topic.arn}"
  depends_on = ["aws_sns_topic.splunk_config_topic"]
  policy = "${data.aws_iam_policy_document.sns-topic-policy.json}"
}


# Topic policy
data "aws_iam_policy_document" "sns-topic-policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive",
    ]

    condition {
      test     = "ArnLike"
      variable = "AWS:SourceArn"

      values = [
        "arn:aws:s3:*:*:${var.s3-splunk-buckets}",
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "${aws_sns_topic.splunk_config_topic.arn}",
    ]

    sid = "__default_statement_ID"
  }
}

# Subscribe the topic the queue
resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = "${aws_sns_topic.splunk_config_topic.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.splunk_config_queue.arn}"
}

# S3 create notifications for object changes
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${var.s3-splunk-buckets}"

  topic {
    topic_arn     = "${aws_sns_topic.splunk_config_topic.arn}"
    events        = ["s3:ObjectCreated:*"]
  }
}
