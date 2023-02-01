FROM swift:5.5.3-amazonlinux2 as builder
ARG TARGET_NAME
RUN yum -y install git jq tar zip openssl-devel && rm -rf /var/cache/yum
WORKDIR /build-lambda
COPY . ./
RUN swift package clean
RUN swift build

