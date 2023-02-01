FROM ubuntu:16.04

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV NPM_CONFIG_LOGLEVEL warn

RUN echo 'deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu xenial main' > /etc/apt/sources.list.d/deadsnakes-ubuntu-ppa-xenial.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6A755776 \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    ca-certificates \
    shellcheck \
    libffi-dev \
    python \
    python-dev \
    python-pip \
    python-pkg-resources \
    python3 \
    python3-dev \
    python3-setuptools \
    python3-pip \
    python3-pkg-resources \
    python3.6 \
    python3.6-dev \
    git \
    libssl-dev \
    openssh-client \
    && curl -f -sSL https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
    && apt-get install -y --no-install-recommends git-lfs \
    && curl -f -sSL -o /usr/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.15.0/hadolint-Linux-x86_64 \
    && chmod a+x /usr/bin/hadolint \
    && pip3 install --no-cache-dir -U pip wheel tox && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install --no-install-recommends -y nodejs \
    && npm install -g \
    eslint csslint sass-lint jsonlint stylelint \
    eslint-plugin-react eslint-plugin-react-native \
    babel-eslint \
    && rm -rf /var/lib/apt/list/* /tmp/* /var/tmp/* && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
