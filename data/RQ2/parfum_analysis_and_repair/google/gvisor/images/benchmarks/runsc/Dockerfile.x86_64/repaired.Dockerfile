FROM ubuntu:18.04

RUN set -x \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
            wget \
            git \
            pkg-config \
            zip \
            g++ \
            zlib1g-dev \
            unzip \
            python-minimal \
            python3 \
            python3-pip \
        && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/bazelbuild/bazel/releases/download/3.4.1/bazel-3.4.1-installer-linux-x86_64.sh
RUN chmod +x bazel-3.4.1-installer-linux-x86_64.sh
RUN ./bazel-3.4.1-installer-linux-x86_64.sh

# Download release-20200601.0
RUN mkdir gvisor && cd gvisor \
    && git init && git remote add origin https://github.com/google/gvisor.git \
    && git fetch --depth 1 origin a9b47390c821942d60784e308f681f213645049c && git checkout FETCH_HEAD
