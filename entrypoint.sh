#!/usr/bin/env bash

REPO_NAME=$INPUT_ECR_REPOSITORY
IMAGE_TAG=$INPUT_IMAGE_TAG

aws ecr start-image-scan --repository-name $REPO_NAME --image-id imageTag=$IMAGE_TAG
aws ecr wait image-scan-complete --repository-name $REPO_NAME --image-id imageTag=$IMAGE_TAG

if [ $(echo $?) -eq 0 ]; then
    SCAN_FINDINGS=$(aws ecr describe-image-scan-findings --repository-name $REPO_NAME --image-id imageTag=$IMAGE_TAG | jq '.imageScanFindings.findingSeverityCounts')
    CRITICAL=$(echo $SCAN_FINDINGS | jq '.CRITICAL')
    HIGH=$(echo $SCAN_FINDINGS | jq '.HIGH')
    if [ $CRITICAL != null ] || [ $HIGH != null ]; then
        echo -e "Found vulnerabilities in Docker image \n$CRITICAL CRITICAL and $HIGH HIGH level"
        status="unsafe"
        echo "status=$status" >> $GITHUB_OUTPUT
    else
        echo "No vulnerabilites found"
        status="safe"
        echo "status=$status" >> $GITHUB_OUTPUT
    fi
fi