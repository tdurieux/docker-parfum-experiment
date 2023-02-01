# Allow base image override
ARG BASE_IMAGE="harbor.k8s.temple.edu/library/ruby:2.7-alpine"

# hadolint ignore=DL3006,DL3026
FROM "${BASE_IMAGE}"

WORKDIR /app

COPY . .

USER root

ARG SECRET_KEY_BASE

# libc6-compat is required for m1 build.