FROM golang:1.17-bullseye
LABEL deepfence.role=system

WORKDIR /go
ADD cloud_detect/steampipe-plugin-overrides/ /tmp/steampipe-plugin-overrides/
RUN apt-get update \
    && git clone --depth 1 --branch v0.29.0 https://github.com/turbot/steampipe-plugin-aws.git /go/steampipe-plugin-aws \
    && cp /tmp/steampipe-plugin-overrides/steampipe-plugin-aws/aws/* /go/steampipe-plugin-aws/aws/ \
    && cp /tmp/steampipe-plugin-overrides/steampipe-plugin-aws/Makefile /go/steampipe-plugin-aws/ \
    && git clone --depth 1 --branch v0.15.0 https://github.com/turbot/steampipe-plugin-gcp.git /go/steampipe-plugin-gcp \
    && cp /tmp/steampipe-plugin-overrides/steampipe-plugin-gcp/gcp/* /go/steampipe-plugin-gcp/gcp/ \
    && cp /tmp/steampipe-plugin-overrides/steampipe-plugin-gcp/Makefile /go/steampipe-plugin-gcp/ \
    && git clone --depth 1 --branch v0.17.0 https://github.com/turbot/steampipe-plugin-azure.git /go/steampipe-plugin-azure \
    && cp /tmp/steampipe-plugin-overrides/steampipe-plugin-azure/azure/* /go/steampipe-plugin-azure/azure/ \
    && cp /tmp/steampipe-plugin-overrides/steampipe-plugin-azure/Makefile /go/steampipe-plugin-azure/ \
    && cd /go/steampipe-plugin-aws \
    && make \
    && cd /go/steampipe-plugin-gcp \
    && make \
    && cd /go/steampipe-plugin-azure \
    && make