FROM arm32v7/ubuntu:20.04

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
ENV DESTCPU {{ arch }}
ENV ARCH {{ arch }}
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get dist-upgrade -y && apt-get install --no-install-recommends -y ccache \
      g++-8 \
      gcc-8 \
      git \
      openjdk-8-jre-headless \
      pkg-config \
      curl \
      python3-pip \
      python-is-python3 \
      libfontconfig1 && rm -rf /var/lib/apt/lists/*;

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
