# Docker hub destination: sim590/dpaste-ci
FROM debian:buster-slim
MAINTAINER Simon Désaulniers <sim.desaulniers@gmail.com>
RUN apt-get update && apt-get install --no-install-recommends -y \
        build-essential \
        autoconf \
        automake \
        libopendht-dev \
        libb64-dev \
        libcurlpp-dev \
        libcurl4-openssl-dev \
        libgpgmepp-dev \
        libgpgme-dev \
        nlohmann-json-dev \
        libglibmm-2.4-dev \
        catch && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

#  vim: set ft=dockerfile ts=4 sw=4 tw=120 et :

