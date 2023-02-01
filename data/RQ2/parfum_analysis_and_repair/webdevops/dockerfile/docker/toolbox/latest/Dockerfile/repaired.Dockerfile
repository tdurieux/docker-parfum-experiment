#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/toolbox:latest
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM alpine:latest

RUN apk add --no-cache \
        ca-certificates \
        openssl \
        curl \
        bash \
        sed \
        wget \
        zip \
        unzip \
        bzip2 \
        p7zip \
        drill \
        ldns \
        openssh-client \
        rsync \
        git \
        gnupg \
    ## Install go-replace