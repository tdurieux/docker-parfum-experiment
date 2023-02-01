FROM ubuntu:bionic
RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install \
    software-properties-common git curl wget debhelper devscripts openjdk-8-jre-headless && rm -rf /var/lib/apt/lists/*;
WORKDIR /workspace
