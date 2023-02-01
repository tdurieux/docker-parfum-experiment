FROM ubuntu:16.04

ENV LC_ALL=C

RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install --no-install-recommends -y software-properties-common \
  && add-apt-repository ppa:ubuntu-toolchain-r/test \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    ccache \
    g++ \
    gcc \
    git \
    openjdk-8-jre-headless \
    curl \
    python-pip \
    python3-pip \
    python-all \
    python-software-properties \
    libfontconfig1 \
    make \
    gcc-4.9-multilib \
    g++-4.9-multilib \
    gcc-6-multilib \
    g++-6-multilib && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir tap2junit \
  && pip3 install --no-cache-dir tap2junit

RUN git clone https://github.com/rvagg/rpi-newer-crosstools.git /opt/raspberrypi/rpi-newer-crosstools

COPY cc-selector.sh /opt/raspberrypi/cc-selector.sh

RUN chmod 755 /opt/raspberrypi/cc-selector.sh

RUN addgroup --gid {{ server_user_gid.stdout_lines[0] }} {{ server_user }} \
 && adduser --gid {{ server_user_gid.stdout_lines[0] }} --uid {{ server_user_uid.stdout_lines[0] }} --disabled-password --gecos {{ server_user }} {{ server_user }}

VOLUME /home/{{ server_user }}/ /home/{{ server_user }}/.ccache

USER {{ server_user }}:{{ server_user }}

ENV USER={{ server_user }} \
  JOBS={{ server_jobs | default(ansible_processor_vcpus) }} \
  SHELL=/bin/bash \
  HOME=/home/{{ server_user }} \
  PATH=/usr/lib/ccache/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  NODE_COMMON_PIPE=/home/{{ server_user }}/test.pipe \
  NODE_TEST_DIR=/home/{{ server_user }}/tmp \
  OSTYPE=linux-gnu \
  OSVARIANT=docker \
  DESTCPU={{ arch }} \
  ARCH={{ arch }} \
  CCACHE_TEMPDIR=/home/{{ server_user }}/.ccache/{{ item.name }}

CMD cd /home/{{ server_user }} \
  && curl https://ci.nodejs.org/jnlpJars/slave.jar -O \
  && java -Xmx{{ server_ram|default('128m') }} \
          -jar /home/{{ server_user }}/slave.jar \
          -jnlpUrl {{ jenkins_url }}/computer/{{ item.name }}/slave-agent.jnlp \
          -secret {{ item.secret }}
