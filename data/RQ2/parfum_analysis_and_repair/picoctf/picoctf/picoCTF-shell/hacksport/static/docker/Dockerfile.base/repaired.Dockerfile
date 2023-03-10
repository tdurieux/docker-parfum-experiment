# Stage 1. base
# This stage is intended to be built from an empty context and ensure a common
# set of dependencies. This is portable across environments and should rarely
# require a rebuild or breaking cache. Is intended to match the default shell
# server environment

FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

# challenge building and hosting dependencies
# pulled from ansible/pico-shell/tasks/dependencies.yml
RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    dpkg-dev \
    dpkg \
    fakeroot \
    gcc-multilib \
    iptables-persistent \
    libffi-dev \
    libssl-dev \
    netfilter-persistent \
    nfs-common \
    nodejs \
    php7.2-cli \
    php7.2-sqlite3 \
    python-pip \
    python-virtualenv \
    python3-pip \
    python3.7-dev \
    python3.7-venv \
    python3.7 \
    python3 \
    python-flask \
    socat \
    software-properties-common \
    uwsgi \
    uwsgi-plugin-php \
    uwsgi-plugin-python \
    uwsgi-plugin-python3 \
    xinetd && rm -rf /var/lib/apt/lists/*;

# additional expected dependencies identified
RUN apt-get update && apt-get install --no-install-recommends -y \
    sudo && rm -rf /var/lib/apt/lists/*;
