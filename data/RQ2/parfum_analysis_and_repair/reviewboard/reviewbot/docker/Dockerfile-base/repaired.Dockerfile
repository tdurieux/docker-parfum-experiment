# Dockerfile for Review Bot.
#
# Copyright (C) 2022 Beanbag, Inc.


##############################################################################
# Stage 1 of the build.
#
# We'll set up some common environment variables we'll want in subsequent
# stages.
#
# We're using Ubuntu (LTS release), due to the longer support life.
##############################################################################
FROM ubuntu:20.04 AS base

# Version of Python to use.
ARG PYTHON_VERSION=3.8
ENV PYTHON_VERSION=$PYTHON_VERSION

# Set up Rust environment variables.
ENV RUSTUP_HOME=/opt/rust/rustup
ENV CARGO_HOME=/opt/rust/cargo

# Set up Ruby environment variables.
ENV GEM_HOME=/opt/ruby/gems

# Set up Node.JS environment variables.
ENV NPM_CONFIG_PREFIX=/opt/nodejs/node_modules

# Set up a virtualenv for Review Board.
ENV VIRTUAL_ENV=/opt/venv

# Set up the environment for Python and scripts.
ENV LANG=C.UTF-8
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# Common environment variables.
ENV PATH="$CARGO_HOME/bin:$NPM_CONFIG_PREFIX/bin:$GEM_HOME/bin:$VIRTUAL_ENV/bin:$PATH"


##############################################################################
# Stage 2 of the build.
#
# We'll set up development support and compile any modules we need in a
# virtualenv. That will be copied in stage 2 to the destination image, without
# carrying all the development bloat.
#
##############################################################################
FROM base AS builder
MAINTAINER Beanbag, Inc. <support@beanbaginc.com>

# The version of Review Bot this will install.
ARG REVIEWBOT_VERSION=3.1.0

# Version of PMD to install.
ARG PMD_VERSION=6.32.0

# Install all the base system-level packages needed by Review Bot.
#
# We will be installing some packages (including most Python packages) via
# pip instead of apt-get.
RUN    set -ex \
    && apt-get update -y \
    && DEBIAN_FRONTEND="noninteractive" apt-get install \
           -y --no-install-recommends \
           build-essential \
           ca-certificates \
           curl \
           nodejs \
           npm \
		   patch \
           ruby \
           software-properties-common \
           unzip \
           virtualenv \
    && rm -rf /var/lib/apt/lists/*

# Add apt repositories for tools we need.
#
# NOTE: Update the "deb" line when modifying the base Ubuntu version!
RUN add-apt-repository ppa:longsleep/golang-backports

RUN virtualenv -p python$PYTHON_VERSION $VIRTUAL_ENV

# Install Review Bot and its Python dependencies.
#
# If any packages are provided in ./packages/ when building this, we'll
# prioritize those.
COPY ./packages /tmp/packages
RUN set -ex \
    && pip3 install --no-cache-dir -U pip \
    && pip3 install \
           --no-cache-dir \
           --pre \
           --find-links /tmp/packages \
           reviewbot-worker~=${REVIEWBOT_VERSION} \
	&& pip3 install \
           --no-cache-dir \
           'reviewbot-worker[all]' \
    && rm -rf /tmp/packages

# Install Rust and packages.
RUN    { curl https://sh.rustup.rs -sSf | sh -s -- -y --profile=minimal; } \
    && rustup component add rustfmt

# Install PMD.
RUN set -ex \
    && curl -f -sSL -o /tmp/pmd.zip \
           https://github.com/pmd/pmd/releases/download/pmd_releases%2F${PMD_VERSION}/pmd-bin-${PMD_VERSION}.zip \
    && unzip -d /opt /tmp/pmd.zip \
    && rm /tmp/pmd.zip \
    && mv /opt/pmd-bin-${PMD_VERSION} /opt/pmd

# Install Ruby packages.
RUN gem install --no-document rubocop

# Install Node.JS packages.
RUN npm install -g jshint && npm cache clean --force;

COPY scripts/* /opt/scripts/


##############################################################################
# Stage 2 of the build.
#
# We'll create a new, final image that contains the virtualenv and only the
# runtime dependencies necessary to run Review Board.
##############################################################################
FROM base

# Review Bot user ID
#
# Review Bot will run as this user, and writable directories (/repos/) will be
# owned by this user.
ARG REVIEWBOT_USER_ID=1001

# Review Bot group ID
#
# Writable directories (/repos) will be owned by this group.
ARG REVIEWBOT_GROUP_ID=1001

# Version of PMD to install.
ARG PMD_VERSION=6.32.0

# Public port that gunicorn will listen to.
EXPOSE 8080

# The broker URL to connect to.
#
# This is required.
ENV BROKER_URL=amqp://reviewbot:reviewbot123@rabbitmq/reviewbot

# Log level for Review Bot.
ENV LOG_LEVEL=INFO

# Number of workers to run concurrently.
#
# If blank, this will be based on the number of CPUs on the system.
ENV NUM_WORKERS=

# Location of the repository checkouts directory.
#
# Mount this somewhere to share any repository checkouts across containers.
VOLUME /repos

# Create a user for the web server and set up symlinks for the repositories
# directory.
RUN    groupadd -r reviewbot -g $REVIEWBOT_GROUP_ID \
    && adduser --system --uid $REVIEWBOT_USER_ID \
               --disabled-password --disabled-login \
               --ingroup reviewbot reviewbot \
    && mkdir -p /usr/local/share/reviewbot \
    && ln -s /usr/local/share/reviewbot/repositories /repos

COPY --from=builder /etc/apt /etc/apt

RUN    apt-get update -y \
    && DEBIAN_FRONTEND="noninteractive" apt-get install \
           -y --no-install-recommends \
           ca-certificates \
           checkstyle \
           clang \
           clang-tools \
           cppcheck \
           curl \
           git \
           golang-go \
           gosu \
           nodejs \
           openjdk-14-jre-headless \
           patch \
           python$PYTHON_VERSION \
           python$PYTHON_VERSION-distutils \
           ruby \
           shellcheck \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/python$PYTHON_VERSION /usr/bin/python3

# FBinfer is 300MB!
#    && mkdir -p /opt/fbinfer \
#    && { curl -sSL https://github.com/facebook/infer/releases/download/v${FBINFER_VERSION}/infer-linux64-v${FBINFER_VERSION}.tar.xz" \
#       | tar -xJ -C /opt

# Set up the configuration file.
COPY files/reviewbot-config.py /etc/xdg/reviewbot/config.py

COPY --from=builder /opt /opt

# Periodically check that the worker is up and responding.
HEALTHCHECK CMD /opt/scripts/docker-healthcheck.sh

# Run the Review Bot worker.
ENTRYPOINT ["/opt/scripts/docker-entrypoint.sh"]
CMD ["/opt/scripts/run-reviewbot.sh"]
