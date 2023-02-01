FROM alpine:latest

LABEL maintainer="LitmusChaos"

RUN apk add --no-cache nfs-utils && apk add --no-cache python3

COPY nfs-mount-liveness-check.py /