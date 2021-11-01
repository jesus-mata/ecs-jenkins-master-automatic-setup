#!/bin/bash
set -e

aws_account_id=$(aws sts get-caller-identity --query Account --output text | cat)
version=$(git rev-parse --short=7 HEAD)
region="us-west-2"

#Image name
image="infra/jenkins"

echo "-> Preparing to release database: '$image' version: $version"

#Read flags
while getopts e:r:aa: flag; do
  case "${flag}" in
  r) region=${OPTARG} ;;
  *) usage ;;
  esac
done

ecr_registry="$aws_account_id.dkr.ecr.$region.amazonaws.com"
ecr_repo="$ecr_registry/$image"

#Build the image
docker build -t "$image" .

echo "-> Tagging image..."
#Tag the image
docker tag "$image:latest" "$ecr_repo":latest
docker tag "$image:latest" "$ecr_repo:$version"

echo "-> Logging to ECR..."
#logs to ECR
aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$ecr_registry"

#Push image to ECR
echo "-> Pushing database image $image:$version to ECR $ecr_repo ..."
docker push "$ecr_repo":latest
docker push "$ecr_repo:$version"

#Clean pushed images locally
docker rmi "$ecr_repo":latest
docker rmi "$ecr_repo:$version"

echo "-> Image $ecr_repo:$version has been successfully pushed to ECR."

usage() {
  echo "Usage: $0 [-r <aws_region>]" 1>&2
  exit 1
}
