FROM ubuntu:20.04

ENV LC_ALL C
ENV USER {{ server_user }}
ENV JOBS {{ server_jobs | default(ansible_processor_vcpus) }}
ENV SHELL /bin/bash
ENV HOME /home/{{ server_user }}
ENV PATH /usr/lib/ccache:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV NODE_COMMON_PIPE /home/{{ server_user }}/test.pipe
ENV NODE_TEST_DIR /home/{{ server_user }}/tmp
ENV OSTYPE linux-gnu
ENV OSVARIANT docker
ENV DESTCPU {{ arch }}
ENV ARCH {{ arch }}
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends apt-utils -y && \
    apt-get dist-upgrade -y && apt-get install --no-install-recommends -y \
      ccache \
      g++-8 \
      gcc-8 \
      git \
      openjdk-8-jre-headless \
      pkg-config \
      curl \
      python3-pip \
      python-is-python3 \
      libfontconfig1 \
      libtool \
      automake && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir tap2junit

RUN addgroup --gid {{ server_user_gid.stdout_lines[0] }} {{ server_user }}

RUN adduser --gid {{ server_user_gid.stdout_lines[0] }} --uid {{ server_user_uid.stdout_lines[0] }} --disabled-password --gecos {{ server_user }} {{ server_user }}

ENV ICU64DIR=/opt/icu-64.1 \
    ICU65DIR=/opt/icu-65.1 \
    ICU67DIR=/opt/icu-67.1 \
    ICU68DIR=/opt/icu-68.2 \
    ICU69DIR=/opt/icu-69.1 \
    ICU71DIR=/opt/icu-71.1

RUN for ICU_ENV in $(env | grep ICU..DIR); do \
    ICU_PREFIX=$(echo $ICU_ENV | cut -d '=' -f 2) && \
    ICU_VERSION=$(echo $ICU_PREFIX | cut -d '-' -f 2) && \
    ICU_MAJOR=$(echo $ICU_VERSION | cut -d '.' -f 1) && \
    ICU_MINOR=$(echo $ICU_VERSION | cut -d '.' -f 2) && \
    mkdir -p /tmp/icu-$ICU_VERSION && \
    cd /tmp/icu-$ICU_VERSION && \
    curl -f -sL "https://github.com/unicode-org/icu/releases/download/release-$ICU_MAJOR-$ICU_MINOR/icu4c-${ICU_MAJOR}_$ICU_MINOR-src.tgz" | tar zxv --strip=1 && \
    cd source && \
    ./runConfigureICU Linux --prefix=$ICU_PREFIX && \
    make -j $JOBS && \
    make install && \
    rm -rf /tmp/icu-$ICU_VERSION; \
    done

ENV OPENSSL111VER 1.1.1n
ENV OPENSSL111DIR /opt/openssl-$OPENSSL111VER

RUN mkdir -p /tmp/openssl_$OPENSSL111VER && \
    cd /tmp/openssl_$OPENSSL111VER && \
    curl -f -sL https://www.openssl.org/source/openssl-$OPENSSL111VER.tar.gz | tar zxv --strip=1 && \
    ./config --prefix=$OPENSSL111DIR && \
    make -j 6 && \
    make install && \
    rm -rf /tmp/openssl_$OPENSSL111VER

ENV OPENSSL3VER 3.0.2+quic
ENV OPENSSL3DIR /opt/openssl-$OPENSSL3VER
# TODO(richardlau) remove OPENSSL300DIR when the CI has been updated to use OPENSSL3DIR
ENV OPENSSL300DIR $OPENSSL3DIR

RUN mkdir -p /tmp/openssl-$OPENSSL3VER && \
    cd /tmp/openssl-$OPENSSL3VER && \
    git clone https://github.com/quictls/openssl.git -b openssl-$OPENSSL3VER --depth 1 && \
    cd openssl && \
    ./config --prefix=$OPENSSL3DIR && \
    make -j 6 && \
    make install && \
    rm -rf /tmp/openssl-$OPENSSL3VER

ENV ZLIBVER 1.2.12
ENV ZLIB12DIR /opt/zlib_$ZLIBVER

RUN mkdir -p /tmp/zlib_$ZLIBVER && \
    cd /tmp/zlib_$ZLIBVER && \
    curl -f -sL https://zlib.net/zlib-$ZLIBVER.tar.gz | tar zxv --strip=1 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$ZLIB12DIR && \
    make -j 6 && \
    make install && \
    rm -rf /tmp/zlib_$ZLIBVER

VOLUME /home/{{ server_user }}/ /home/{{ server_user }}/.ccache

USER iojs:iojs

ENV CCACHE_TEMPDIR /home/iojs/.ccache/{{ item.name }}

CMD cd /home/iojs \
  && curl https://ci.nodejs.org/jnlpJars/slave.jar -O \
  && java -Xmx{{ server_ram|default('128m') }} \
          -jar /home/{{ server_user }}/slave.jar \
          -jnlpUrl {{ jenkins_url }}/computer/{{ item.name }}/slave-agent.jnlp \
          -secret {{ item.secret }}
