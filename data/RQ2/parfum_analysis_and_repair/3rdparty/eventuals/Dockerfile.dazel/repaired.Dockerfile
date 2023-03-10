# NOTE: THIS FILE SHOULD BE SPECIFIC TO EVENTUALS AND ONLY INCLUDE
# DEPENDENCIES NECESSARY FOR BUILDING AND TESTING AND NOTHING MORE! DO
# NOT SHARE THIS FILE WITH ANOTHER REPOSITORY BECAUSE THEN IT MIGHT
# BECOME DIFFICULT TO DETERMINE ONLY THOSE DEPENDENCIES NECESSARY FOR
# EVENTUALS.

# Start from Debian with Python 3.9 preinstalled since it's required
# for 'protoc-gen-eventuals'.
#
# TODO(benh): update to Python 3.10.
FROM python:3.9-slim-bullseye

ARG BAZEL_VERSION=5.1.1
ARG CLANG_VERSION=14

# Install generic dependencies.
#
# curl and gnupg are needed to install bazel.
#
# TODO(benh): are 'ca-certificates' or 'ssh-client' necessary?
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg \
    git \
    ssh-client \
    curl \
    wget && rm -rf /var/lib/apt/lists/*;

# Install build tools for some of the 3rdparty dependencies that are
# outside/foreign to Bazel.
RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    make && rm -rf /var/lib/apt/lists/*;

# Install Bazel:
# https://docs.bazel.build/versions/main/install-ubuntu.html#install-on-ubuntu
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" > \
    /etc/apt/sources.list.d/bazel.list \
    && curl -fsSL https://bazel.build/bazel-release.pub.gpg | apt-key add - \
    && apt-get update && apt-get install --no-install-recommends -y bazel=${BAZEL_VERSION} && rm -rf /var/lib/apt/lists/*;

# Install clang (and its dependencies).
RUN apt-get update && apt-get install -y --no-install-recommends \
    lsb-release \
    software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN wget -O /tmp/llvm.sh "https://apt.llvm.org/llvm.sh" \
    && chmod +x /tmp/llvm.sh \
    && /tmp/llvm.sh ${CLANG_VERSION} \
    && rm /tmp/llvm.sh

# Make clang mean clang-xx.
RUN ln -s /usr/bin/clang-${CLANG_VERSION} /usr/bin/clang

# Cleanup.
RUN apt-get purge --auto-remove -y \
    && rm -rf /etc/apt/sources.list.d/bazel.list \
    && rm -rf /var/lib/apt/lists/*
