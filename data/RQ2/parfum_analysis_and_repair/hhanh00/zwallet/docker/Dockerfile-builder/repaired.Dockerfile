#syntax=docker/dockerfile:1.2
FROM archlinux:base-devel-20220227.0.49015 AS builder_rust

COPY install-rust.sh .
RUN ./install-rust.sh

FROM builder_rust as builder_flutter

COPY install-deps.sh .
RUN --mount=type=cache,target=/tmp ./install-deps.sh

ENV ANDROID_SDK_ROOT /root/Android/sdk
ENV ANDROID_NDK_HOME $ANDROID_SDK_ROOT/android-ndk-r21e
ENV PATH $PATH:$ANDROID_SDK_ROOT/platform-tools:/root/flutter/bin