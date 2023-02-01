FROM google/cloud-sdk:alpine

WORKDIR /kms

RUN apk -U --no-cache add jq bash
ENV PATH=${PATH}:/kms

COPY google-kms.sh ./kms


