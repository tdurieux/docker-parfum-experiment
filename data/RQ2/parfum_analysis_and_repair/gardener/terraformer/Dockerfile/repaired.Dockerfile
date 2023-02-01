# SPDX-FileCopyrightText: 2020 SAP SE or an SAP affiliate company and Gardener contributors
#
# SPDX-License-Identifier: Apache-2.0

############# golang-base
FROM golang:1.16.3 AS golang-base

############# terraform-base
FROM golang-base AS terraform-base

# install unzip (needed for unzipping terraform provider plugins)
RUN apt-get update && \
    apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp/terraformer
COPY ./build/fetch-providers.sh .

# overwrite to build provider-specific image
ARG PROVIDER=all

# copy provider-specifc TF_VERSION
COPY ./build/$PROVIDER/TF_VERSION .

RUN export TF_VERSION=$(cat ./TF_VERSION) && \
    # install terraform and needed provider plugins
    mkdir -p /go/src/github.com/hashicorp && \
    git clone --single-branch --depth 1 --branch v${TF_VERSION} https://github.com/hashicorp/terraform.git /go/src/github.com/hashicorp/terraform && \
    cd /go/src/github.com/hashicorp/terraform && \
    go install ./tools/terraform-bundle

# copy provider-specific terraform-bundle.hcl
COPY ./build/$PROVIDER/terraform-bundle.hcl .
RUN ./fetch-providers.sh

############# builder
FROM golang-base AS builder

WORKDIR /go/src/github.com/gardener/terraformer
COPY . .

ARG PROVIDER=all

RUN make install PROVIDER=$PROVIDER

############# terraformer
FROM alpine:3.15.4 AS terraformer

# add additional packages that are required by provider plugins
RUN apk add --no-cache --update tzdata

WORKDIR /

ENV TF_DEV=true
ENV TF_RELEASE=true

COPY --from=terraform-base /tmp/terraformer/terraform /bin/terraform
COPY --from=terraform-base /tmp/terraformer/tfproviders/ /terraform-providers/
COPY --from=builder /go/bin/terraformer /

ENTRYPOINT ["/terraformer"]

############# dev
FROM golang-base AS dev

WORKDIR /go/src/github.com/gardener/terraformer
VOLUME /go/src/github.com/gardener/terraformer

COPY --from=terraform-base /tmp/terraformer/terraform /bin/terraform
COPY --from=terraform-base /tmp/terraformer/tfproviders/ /terraform-providers/

COPY vendor vendor
COPY Makefile VERSION go.mod go.sum ./

RUN make install-requirements
