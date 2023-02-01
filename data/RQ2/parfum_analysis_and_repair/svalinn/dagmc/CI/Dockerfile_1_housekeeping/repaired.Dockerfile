ARG UBUNTU_VERSION=18.04
ARG OWNER=svalinn
ARG TAG=latest
FROM ghcr.io/${OWNER}/dagmc-ci-ubuntu-${UBUNTU_VERSION}:$TAG

RUN pip install --no-cache-dir sphinx; \
    apt-get -y --no-install-recommends install clang-format && rm -rf /var/lib/apt/lists/*;
