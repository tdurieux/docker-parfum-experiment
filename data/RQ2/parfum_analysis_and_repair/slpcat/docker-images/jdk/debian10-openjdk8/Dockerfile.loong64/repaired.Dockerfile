FROM slpcat/debian:buster

MAINTAINER 若虚 <slpcat@qq.com>

# Install required packages
RUN \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install --no-install-recommends -y openjdk-8-jdk-headless && \
    rm -rf /var/lib/apt/lists/ && rm -rf /var/lib/apt/lists/*;
