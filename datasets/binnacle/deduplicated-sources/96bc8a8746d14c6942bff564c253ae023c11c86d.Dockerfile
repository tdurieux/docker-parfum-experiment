# Dockerfile for bindgen, used for automated testing on travis-ci.org

FROM ubuntu:xenial
ARG CLANG_VERSION=5.0
ARG DISTRIB_CODENAME=xenial

COPY . /

RUN ci/install_debian.sh
RUN make -C clang
