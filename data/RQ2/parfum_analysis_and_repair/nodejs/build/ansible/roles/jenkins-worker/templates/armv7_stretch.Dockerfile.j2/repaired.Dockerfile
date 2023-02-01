FROM arm32v7/debian:stretch

ENV LC_ALL=C \
    USER={{ server_user }} \
    JOBS={{ jobs_env }} \
    SHELL=/bin/bash \
    HOME=/home/{{ server_user }} \
    PATH=/usr/lib/ccache:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    NODE_COMMON_PIPE=/home/{{ server_user }}/test.pipe \
    NODE_TEST_DIR=/home/{{ server_user }}/tmp \
    OSTYPE=linux-gnu \
    OSVARIANT=docker \
    DESTCPU=arm \
    ARCH={{ arch }} \
    CCACHE_TEMPDIR=/home/{{ server_user }}/.ccache/{{ inventory_hostname }} \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get dist-upgrade -y && apt-get install --no-install-recommends -y \
      g++-6 \
      gcc-6 \
      git \
      make \
      ccache \
      python2.7 \
      python \
      openssh-client \
      gzip \
      xz-utils \
      procps \
      curl && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 50 && \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-6 50 && \
    update-alternatives --install /usr/bin/cpp cpp /usr/bin/gcc-6 50 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 50 && \
    update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-6 50

RUN ln -sf /usr/bin/ccache /usr/lib/ccache/gcc && \
    ln -sf /usr/bin/ccache /usr/lib/ccache/cc && \
    ln -sf /usr/bin/ccache /usr/lib/ccache/g++ && \
    ln -sf /usr/bin/ccache /usr/lib/ccache/c++ && \
    ln -sf /usr/bin/ccache /usr/lib/ccache/cpp

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

ENTRYPOINT [ "tail", "-f", "/dev/null" ]
