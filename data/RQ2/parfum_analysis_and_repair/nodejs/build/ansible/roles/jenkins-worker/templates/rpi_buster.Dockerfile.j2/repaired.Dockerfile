FROM balenalib/rpi-raspbian:buster

ENV LC_ALL=C \
    USER={{ server_user }} \
    JOBS={{ jobs_env }} \
    SHELL=/bin/bash \
    HOME=/home/{{ server_user }} \
    PATH=/usr/lib/ccache/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    NODE_COMMON_PIPE=/home/{{ server_user }}/test.pipe \
    NODE_TEST_DIR=/home/{{ server_user }}/tmp \
    OSTYPE=linux-gnu \
    OSVARIANT=docker \
    DESTCPU=arm \
    ARCH={{ arch }} \
    CCACHE_TEMPDIR=/home/{{ server_user }}/.ccache/{{ inventory_hostname }} \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get dist-upgrade -y && apt-get install --no-install-recommends -y \
      g++-8 \
      gcc-8 \
      git \
      make \
      ccache \
      python2.7 \
      python \
      openssh-client \
      gzip \
      xz-utils \
      curl \
      libffi-dev \
      zlib1g-dev && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 50 && \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-8 50 && \
    update-alternatives --install /usr/bin/cpp cpp /usr/bin/gcc-8 50 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 50 && \
    update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-8 50

RUN mkdir /python && \
    cd /python && \
    curl -f https://github.com/python/cpython/archive/refs/tags/v3.9.4.tar.gz -L --output v3.9.4.tar.gz && \
    tar xf v3.9.4.tar.gz && \
    cd cpython-3.9.4 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make install && \
    rm -rf /python && rm v3.9.4.tar.gz

RUN addgroup \
      --gid {{ server_user_gid.stdout_lines[0] }} \
      {{ server_user }} && \
    adduser \
      --gid {{ server_user_gid.stdout_lines[0] }} \
      --uid {{ server_user_uid.stdout_lines[0] }} \
      --disabled-password \
      --gecos {{ server_user }} \
      {{ server_user }}

VOLUME /home/{{ server_user }}/

USER iojs:iojs

# Prevent Node.js picking up the OS's openssl.cnf, https://github.com/nodejs/node/issues/27862
ENV OPENSSL_CONF /dev/null

ENTRYPOINT [ "tail", "-f", "/dev/null" ]
