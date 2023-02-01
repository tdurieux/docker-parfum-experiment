# Copy and extract HEAVY.AI tarball. In own stage so that the temporary tarball
# isn't included in a layer.
FROM ubuntu:18.04 AS extract

WORKDIR /opt/heavyai/
COPY heavyai-latest-Linux-x86_64.tar.gz /opt/heavyai/
RUN tar xvf heavyai-latest-Linux-x86_64.tar.gz --strip-components=1 && \
    rm -rf heavyai-latest-Linux-x86_64.tar.gz

# Build final stage
FROM nvidia/cudagl:11.0-runtime-ubuntu18.04
LABEL maintainer "Andrew Seidl <andrew@heavy.ai>"

ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics

RUN apt-get update && apt-get install -y --no-install-recommends \
        libldap-2.4-2 \
        bsdmainutils \
        libopengl0 \
        wget \
        curl \
        libvulkan1 \
        clang-9 \
        liblz4-tool \
        libgeos-dev \
        default-jre-headless && \
    apt-get remove --purge -y && \
    rm -rf /var/lib/apt/lists/*

COPY --from=extract /opt/heavyai /opt/heavyai

# UDF support