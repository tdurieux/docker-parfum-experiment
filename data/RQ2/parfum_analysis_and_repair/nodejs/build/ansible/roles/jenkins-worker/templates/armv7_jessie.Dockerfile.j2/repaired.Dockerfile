FROM arm32v7/debian:jessie

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
      g++-4.9 \
      gcc-4.9 \
      git \
      make \
      zlib1g \
      zlib1g-dev \
      python2.7 \
      python \
      openssh-client \
      gzip \
      xz-utils \
      procps \
      curl && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 50 && \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-4.9 50 && \
    update-alternatives --install /usr/bin/cpp cpp /usr/bin/gcc-4.9 50 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 50 && \
    update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-4.9 50

RUN addgroup \
      --gid {{ server_user_gid.stdout_lines[0] }} \
      {{ server_user }} && \
    adduser \
      --gid {{ server_user_gid.stdout_lines[0] }} \
      --uid {{ server_user_uid.stdout_lines[0] }} \
      --disabled-password \
      --gecos {{ server_user }} \
      {{ server_user }}

RUN curl -f -sL https://www.samba.org/ftp/ccache/ccache-{{ ccache_latest }}.tar.gz | tar zxv -C /tmp/ && \
    cd /tmp/ccache-{{ ccache_latest }} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make -j {{ jobs_env }} && \
    install -c -m 755 ccache /usr/local/bin && \
    ln -s /usr/local/bin/ccache /usr/local/bin/gcc && \
    ln -s /usr/local/bin/ccache /usr/local/bin/cc && \
    ln -s /usr/local/bin/ccache /usr/local/bin/g++ && \
    ln -s /usr/local/bin/ccache /usr/local/bin/c++ && \
    ln -s /usr/local/bin/ccache /usr/local/bin/cpp && \
    rm -rf /tmp/ccache-{{ ccache_latest }}

VOLUME /home/{{ server_user }}/

USER iojs:iojs

ENTRYPOINT [ "tail", "-f", "/dev/null" ]
