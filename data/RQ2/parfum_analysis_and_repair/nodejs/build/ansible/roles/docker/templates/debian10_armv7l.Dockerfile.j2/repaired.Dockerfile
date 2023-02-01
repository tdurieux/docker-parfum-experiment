FROM arm32v7/debian:10

ENV LC_ALL C
ENV USER {{ server_user }}
ENV JOBS {{ server_jobs | default(ansible_processor_vcpus) }}
ENV SHELL /bin/bash
ENV HOME /home/{{ server_user }}
ENV PATH /usr/lib/ccache/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV NODE_COMMON_PIPE /home/{{ server_user }}/test.pipe
ENV NODE_TEST_DIR /home/{{ server_user }}/tmp
ENV OSTYPE linux-gnu
ENV OSVARIANT docker
ENV PYTHON python3
ENV DESTCPU {{ arch }}
ENV ARCH {{ arch }}
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get dist-upgrade -y && apt-get install --no-install-recommends -y ccache \
      curl \
      g++-8 \
      gcc-8 \
      git \
      libfontconfig1 \
      openjdk-11-jre-headless \
      pkg-config \
      procps \
      python3-pip \
      xz-utils && rm -rf /var/lib/apt/lists/*;

# Prevent Node.js picking up the OS's openssl.cnf, https://github.com/nodejs/node/issues/27862
ENV OPENSSL_CONF /dev/null

RUN pip3 install --no-cache-dir tap2junit

RUN addgroup --gid {{ server_user_gid.stdout_lines[0] }} {{ server_user }}

RUN adduser --gid {{ server_user_gid.stdout_lines[0] }} --uid {{ server_user_uid.stdout_lines[0] }} --disabled-password --gecos {{ server_user }} {{ server_user }}

VOLUME /home/{{ server_user }}/ /home/{{ server_user }}/.ccache

USER iojs:iojs

ENV CCACHE_TEMPDIR /home/iojs/.ccache/{{ item.name }}

CMD cd /home/iojs \
  && curl https://ci.nodejs.org/jnlpJars/slave.jar -O \
  && java -Xmx{{ server_ram|default('128m') }} \
          -jar /home/{{ server_user }}/slave.jar \
          -jnlpUrl {{ jenkins_url }}/computer/{{ item.name }}/slave-agent.jnlp \
          -secret {{ item.secret }}
