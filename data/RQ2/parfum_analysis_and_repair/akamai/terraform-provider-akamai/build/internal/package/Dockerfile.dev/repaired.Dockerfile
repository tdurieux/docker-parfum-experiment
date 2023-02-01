# syntax=docker/dockerfile:1.0-experimental
ARG TERRAFORM_VERSION
FROM golang:1.15.1-alpine AS builder
ENV GO111MODULE="on" \
     CGO_ENABLED=0 \
     GOOS="linux" \
     GOARCH="amd64"
WORKDIR $GOPATH/src/github.com/akamai
COPY terraform-provider-akamai terraform-provider-akamai
COPY akamaiopen-edgegrid-golang akamaiopen-edgegrid-golang

RUN cd terraform-provider-akamai \
    && go mod edit -replace github.com/akamai/AkamaiOPEN-edgegrid-golang/v2=../akamaiopen-edgegrid-golang \
    && go install -tags all \
    && go mod edit -dropreplace github.com/akamai/AkamaiOPEN-edgegrid-golang/v2

FROM hashicorp/terraform:0.13.5
ENV PROVIDER_VERSION="1.0.0"
COPY --from=builder /go/bin/terraform-provider-akamai /root/.terraform.d/plugins/registry.terraform.io/akamai/akamai/${PROVIDER_VERSION}/linux_amd64/terraform-provider-akamai_v${PROVIDER_VERSION}
COPY --from=builder /go/bin/terraform-provider-akamai /root/.terraform.d/plugins/registry.terraform.io/-/akamai/${PROVIDER_VERSION}/linux_amd64/terraform-provider-akamai_v${PROVIDER_VERSION}