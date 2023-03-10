FROM ubuntu:17.10
ARG docker_ver=17.12.1

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
# links to commit hashes are listed inside posted Dockerfiles https://hub.docker.com/r/library/docker/
# NOTE: must match engine version that is directly pulled from Alpine's Dockerfile
# - go to https://hub.docker.com/r/library/docker/
# - click on the matching alpine version tag (eg, 17.12.0-dind)
# - pull the DIND_COMMIT has from the Dockerfile that opens, for 17.12.0-dind it will be:
#   https://github.com/docker-library/docker/blob/de9fda490429cf83734ef78b58f0ae9cfed1b087/17.12/dind/Dockerfile
ENV DIND_COMMIT 3b5fac462d21ca164b3778647420016315289034

RUN apt-get update -y       \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
       apt-transport-https \
       build-essential \
       bzip2 \
       ca-certificates \
       curl \
       git \
       iptables \
       jq \
       lvm2 \
       lxc \
       openjdk-8-jdk-headless \
       unzip \
       zip && rm -rf /var/lib/apt/lists/*;

# docker
RUN curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | apt-key add -qq - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu artful stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update -qq \
    && apt-get install -y -qq --no-install-recommends docker-ce="${docker_ver}~ce-0~ubuntu" && rm -rf /var/lib/apt/lists/*;
# fetch DIND script
RUN curl -f -sSL https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind -o /usr/local/bin/dind \
    && chmod a+x /usr/local/bin/dind

COPY ./wrapper.sh /usr/local/bin/wrapper.sh
RUN chmod a+x /usr/local/bin/wrapper.sh

VOLUME /var/lib/docker
ENTRYPOINT []
CMD []
