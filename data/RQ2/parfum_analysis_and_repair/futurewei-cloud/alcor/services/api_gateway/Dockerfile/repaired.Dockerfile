# Dockerfile for API Gateway

FROM jboss/base-jdk:11

MAINTAINER Zhonghao Lyu <zlyu@futurewei.com>

# API Gateway process
EXPOSE 9009
# API Gateway admin process

# Generate container image and run container