ARG BASE_IMAGE=ubuntu:20.04

FROM $BASE_IMAGE as builder

COPY build-deps.sh /

RUN /build-deps.sh