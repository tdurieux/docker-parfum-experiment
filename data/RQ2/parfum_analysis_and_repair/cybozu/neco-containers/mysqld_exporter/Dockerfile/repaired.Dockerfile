# metallb container

# Stage1: build from source
FROM quay.io/cybozu/golang:1.17-focal AS build

ARG MYSQLD_EXPORTER_VERSION=v0.14.0

RUN git clone -b ${MYSQLD_EXPORTER_VERSION} --depth 1 https://github.com/prometheus/mysqld_exporter \
    && make -C mysqld_exporter build

# Stage2: setup runtime container