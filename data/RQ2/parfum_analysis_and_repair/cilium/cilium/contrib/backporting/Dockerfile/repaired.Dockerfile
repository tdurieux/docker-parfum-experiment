FROM ubuntu:20.04

LABEL maintainer="maintainer@cilium.io"

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y \
  git \
  golang \
  jq \
  python3 \
  python3-pip \
  curl \
  vim && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /hub && \
    cd /hub \
    && curl -f -L -o hub.tgz https://github.com/github/hub/releases/download/v2.14.0/hub-linux-amd64-2.14.0.tgz \
    && tar xfz hub.tgz \
    && $(tar tfz hub.tgz | head -n1 | cut -f1 -d"/")/install \
    && rm -rf /hub && rm hub.tgz
RUN useradd -m user
USER user
RUN pip3 install --no-cache-dir --user PyGithub
