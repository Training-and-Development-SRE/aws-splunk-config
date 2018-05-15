#!/bin/bash

for var in "$@"
do
    terraform apply -var s3-splunk-buckets-list="$var"
done
