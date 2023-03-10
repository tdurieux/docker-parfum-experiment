# This is the base image for mesosphere/dcos-commons, created in order to
# overcome issues such as DCOS-44265 which come about because neither the 18.04
# tag is immutable, nor the apt-get install command is repeatable.
#
# If you need a new version of this image (either because you require more
# recent versions of the base OS or one of the packages installed here, or
# because you modified this file), there are two ways to use it:
#
# 1) Slower but semi-automatic and public:
# - once the desired version of this file is merged to master, the builder
#   on Jenkins will build and push a new version of this image
# - at that point, renovatebot will make a PR to bump the sha in FROM line in
#   Dockerfile (of the main image)
#
# 2) Faster, for local testing:
# - make the required changes to this file, and/or run the following build
#   command with --no-cache
# $ TAG=$(date +%Y%m%d)-local
# $ docker build -f Dockerfile.base -t mesosphere/dcos-commons-base:$TAG .
# - put the tag into the FROM line in Dockerfile (of the main image)
#   temporarily, rebuild that one, test, etc.
#
FROM ubuntu:18.04@sha256:0925d086715714114c1988f7c947db94064fd385e171a63c07730f1fa014e6f9

# Docker and DIND
# links to commit hashes are listed inside posted Dockerfiles at
# https://hub.docker.com/r/library/docker/
# NOTE: must match engine version that is directly pulled from
# Alpine's Dockerfile:
# - go to https://hub.docker.com/r/library/docker/
# - click on the matching alpine version tag (eg, 17.12.0-dind)
# - pull the DIND_COMMIT hash from the Dockerfile that opens
ARG DOCKER_VERSION=5:18.09.8
ARG DIND_COMMIT=37498f009d8bf25fbb6199e8ccd34bed84f2874b

COPY dind-wrapper.sh /usr/local/bin/dind-wrapper.sh
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        wget \
        gnupg && \
    wget -O - "https://download.docker.com/linux/ubuntu/gpg" \
        | apt-key add -qq - \
    && echo "deb [arch=amd64] \
        https://download.docker.com/linux/ubuntu \
        bionic \
        stable" > /etc/apt/sources.list.d/docker.list \
    && wget -O /usr/local/bin/dind "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind" \
    && chmod a+x /usr/local/bin/dind \
    && chmod a+x /usr/local/bin/dind-wrapper.sh && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python3-software-properties software-properties-common && \
    add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install --no-install-recommends -y -V -oDebug::pkgDepCache::AutoInstall=yes \
    grub-pc- \
    curl \
    docker-ce="${DOCKER_VERSION}~3-0~ubuntu-bionic" \
    git \
    jq \
    libcairo2-dev \
    libgirepository1.0-dev \
    libssl-dev \
    openjdk-11-jdk \
    pkg-config \
    python-pip \
    python3 \
    python3-cairo-dev \
    python3-dev \
    python3-pip \
    rsync \
    tox \
    software-properties-common \
    upx-ucl \
    wget \
    zip && \
    rm -rf /var/lib/apt/lists/* && \
    java -version

#Remove pycrypto-2.6.1 due to https://nvd.nist.gov/vuln/detail/CVE-2018-6594
RUN apt-get remove -y python3-crypto
