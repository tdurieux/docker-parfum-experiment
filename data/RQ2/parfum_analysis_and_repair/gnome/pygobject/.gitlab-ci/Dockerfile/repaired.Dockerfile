FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    ccache \
    curl \
    dbus \
    gir1.2-gtk-3.0 \
    git \
    gobject-introspection \
    lcov \
    libbz2-dev \
    libcairo2-dev \
    libffi-dev \
    libgirepository1.0-dev \
    libglib2.0-dev \
    libgtk-3-0 \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    ninja-build \
    python3-pip \
    xauth \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

ARG HOST_USER_ID=5555
ENV HOST_USER_ID ${HOST_USER_ID}
RUN useradd -u $HOST_USER_ID -ms /bin/bash user

USER user
WORKDIR /home/user

ENV LANG C.UTF-8
ENV CI true
ENV PYENV_ROOT /home/user/.pyenv
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"
ENV PYTHON_CONFIGURE_OPTS="--enable-shared"

RUN curl -f -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

RUN pyenv install pypy3.8-7.3.8
RUN pyenv install --debug 3.7.13
RUN pyenv install --debug 3.8.13
RUN pyenv install --debug 3.9.12
RUN pyenv install --debug 3.10.4

ENV PATH="/usr/lib/ccache:${PATH}"
