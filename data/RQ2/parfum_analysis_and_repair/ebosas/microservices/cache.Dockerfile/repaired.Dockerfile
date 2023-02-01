# FROM golang:1.17-alpine AS cache
# AWS CodeBuild fails due to Docker's pull rate limit, using ECR.