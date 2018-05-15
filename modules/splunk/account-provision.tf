terraform {
  required_version = ">= 0.9.2"
}

resource "aws_iam_user" "splunk" {
  name = "${var.splunk_account_name}"
  path = "/"
}

resource "aws_iam_policy" "policy" {
  name        = "splunk_cloud_es"
  path        = "/"
  description = "Splunk Cloud Enterprise Security Policy"

  policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "VisualEditor0",
              "Effect": "Allow",
              "Action": [
                  "sqs:DeleteMessage",
                  "config:GetComplianceSummaryByConfigRule",
                  "iam:GetAccountPasswordPolicy",
                  "ec2:DescribeInstances",
                  "kms:Decrypt",
                  "sqs:ReceiveMessage",
                  "kinesis:Get*",
                  "elasticloadbalancing:DescribeLoadBalancerPolicyTypes",
                  "ec2:DescribeSnapshots",
                  "cloudwatch:Describe*",
                  "elasticloadbalancing:DescribeLoadBalancers",
                  "kinesis:ListStreams",
                  "ec2:DescribeVolumes",
                  "logs:GetLogEvents",
                  "elasticloadbalancing:DescribeLoadBalancerPolicies",
                  "config:DescribeConfigRules",
                  "ec2:DescribeReservedInstances",
                  "ec2:DescribeKeyPairs",
                  "elasticloadbalancing:DescribeInstanceHealth",
                  "inspector:Describe*",
                  "ec2:DescribeNetworkAcls",
                  "sqs:GetQueueUrl",
                  "lambda:ListFunctions",
                  "iam:GetAccessKeyLastUsed",
                  "sqs:SendMessage",
                  "sqs:GetQueueAttributes",
                  "elasticloadbalancing:DescribeLoadBalancerAttributes",
                  "s3:GetObject",
                  "sts:AssumeRole",
                  "ec2:DescribeSubnets",
                  "s3:GetLifecycleConfiguration",
                  "autoscaling:Describe*",
                  "s3:GetBucketTagging",
                  "ec2:DescribeAddresses",
                  "logs:DescribeLogStreams",
                  "s3:GetBucketLogging",
                  "ec2:DescribeRegions",
                  "s3:ListBucket",
                  "s3:GetAccelerateConfiguration",
                  "sns:Get*",
                  "sns:Publish",
                  "config:GetComplianceDetailsByConfigRule",
                  "elasticloadbalancing:DescribeListeners",
                  "rds:DescribeDBInstances",
                  "cloudwatch:Get*",
                  "config:DeliverConfigSnapshot",
                  "iam:ListAccessKeys",
                  "sqs:ListQueues",
                  "config:DescribeConfigRuleEvaluationStatus",
                  "logs:DescribeLogGroups",
                  "elasticloadbalancing:DescribeTags",
                  "cloudwatch:List*",
                  "kinesis:DescribeStream",
                  "inspector:List*",
                  "ec2:DescribeSecurityGroups",
                  "sns:List*",
                  "ec2:DescribeImages",
                  "s3:ListAllMyBuckets",
                  "ec2:DescribeVpcs",
                  "s3:GetBucketCORS",
                  "cloudfront:ListDistributions",
                  "elasticloadbalancing:DescribeTargetHealth",
                  "elasticloadbalancing:DescribeTargetGroups",
                  "iam:ListUsers",
                  "iam:GetUser",
                  "s3:GetBucketLocation"
              ],
              "Resource": "*"
          }
      ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "attach" {
    user       = "${aws_iam_user.splunk.name}"
    policy_arn = "${aws_iam_policy.policy.arn}"
}
