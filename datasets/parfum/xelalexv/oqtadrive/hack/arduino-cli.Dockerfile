FROM ubuntu:22.04@sha256:bace9fb0d5923a675c894d5c815da75ffe35e24970166a48a4460a48ae6e0d19

ARG BRANCH

ENV DEBIAN_FRONTEND=noninteractive
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=yes

RUN apt-get update && \
    apt-get install -y --no-install-recommends --fix-missing \
        ca-certificates && \
    apt-get upgrade -y --fix-missing && \
    apt-get install -y --no-install-recommends --fix-missing \
        curl \
        jq \
        gawk \
    	make \
        strace && \
    apt-get clean -y && \
    rm -rf \
        /var/cache/debconf/* \
        /var/lib/apt/lists/* \
        /var/log/* \
        /tmp/* \
        /var/tmp/*

RUN mkdir /oqtadrive

COPY ./hack/devenvutil.sh ./hack/Makefile /oqtadrive/

WORKDIR /oqtadrive

RUN BUILD_ONLY=y make get_arduinocli && rm -rf ./hack
