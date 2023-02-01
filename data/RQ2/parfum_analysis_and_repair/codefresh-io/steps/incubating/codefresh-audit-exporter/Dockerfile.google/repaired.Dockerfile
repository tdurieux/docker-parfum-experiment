FROM alpine:3.11

WORKDIR /plugin

RUN apk update && apk add --no-cache curl ca-certificates python bash jq

RUN curl -f -sSL https://sdk.cloud.google.com | bash

ENV PATH $PATH:/root/google-cloud-sdk/bin

RUN apk del bash

COPY . .