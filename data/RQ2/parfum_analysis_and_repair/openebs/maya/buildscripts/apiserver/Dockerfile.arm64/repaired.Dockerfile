#
# This Dockerfile builds a recent maya api server using the latest binary from
# maya api server's releases.
#

#Make the base image configurable. If BASE IMAGES is not provided
#docker command will fail
ARG BASE_IMAGE=arm64v8/ubuntu:18.04
FROM $BASE_IMAGE

# TODO: The following env variables should be auto detected.
ENV MAYA_API_SERVER_NETWORK="eth0"

RUN apt update && apt install --no-install-recommends -y \
    iproute2 \
    bash \
    curl \
    net-tools \
    procps \
    ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /etc/apiserver/orchprovider
RUN mkdir -p /etc/apiserver/specs

COPY demo-vol1.yaml /etc/apiserver/specs/
COPY maya-apiserver /usr/local/bin/
COPY mayactl /usr/local/bin/

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ARG ARCH
ARG DBUILD_DATE
ARG DBUILD_REPO_URL
ARG DBUILD_SITE_URL
LABEL org.label-schema.name="m-apiserver"
LABEL org.label-schema.description="API server for OpenEBS"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$DBUILD_DATE
LABEL org.label-schema.vcs-url=$DBUILD_REPO_URL
LABEL org.label-schema.url=$DBUILD_SITE_URL

ENTRYPOINT entrypoint.sh "${MAYA_API_SERVER_NETWORK}"

EXPOSE 5656
