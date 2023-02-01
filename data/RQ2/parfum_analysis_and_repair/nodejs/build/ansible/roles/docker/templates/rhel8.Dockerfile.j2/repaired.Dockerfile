FROM registry.access.redhat.com/ubi8:latest

ENV LC_ALL C
ENV USER {{ server_user }}
ENV JOBS {{ server_jobs | default(ansible_processor_vcpus) }}
ENV SHELL /bin/bash
ENV PATH /usr/lib64/ccache:/usr/lib/ccache:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV NODE_COMMON_PIPE /home/{{ server_user }}/test.pipe
ENV NODE_TEST_DIR /home/{{ server_user }}/tmp
ENV OSTYPE linux-gnu
ENV OSVARIANT docker
ENV DESTCPU {{ arch }}
ENV ARCH {{ arch }}

# ccache is not in the default repositories so get it from EPEL 8.
RUN dnf install --disableplugin=subscription-manager -y \
      https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && dnf update --disableplugin=subscription-manager -y \
    && dnf install --disableplugin=subscription-manager -y \
      ccache \
      gcc-c++ \
      git \
      java-17-openjdk-headless \
      make \
      python3 \
      procps-ng \
      xz \
    && dnf --disableplugin=subscription-manager clean all

RUN groupadd -r -g {{ server_user_gid.stdout_lines[0] }} {{ server_user }} \
    && adduser -r -m -d /home/{{ server_user }}/ \
      -g {{ server_user_gid.stdout_lines[0] }} \
      -u {{ server_user_uid.stdout_lines[0] }} {{ server_user }}

# Relax crypto policies to allow Node.js tests to pass
RUN update-crypto-policies --set LEGACY

VOLUME /home/{{ server_user }}/ /home/{{ server_user }}/.ccache

ENV PYTHON /usr/bin/python3

RUN pip3 install --no-cache-dir tap2junit

USER {{ server_user }}:{{ server_user }}

ENV CCACHE_TEMPDIR /home/{{ server_user }}/.ccache/{{ item.name }}

WORKDIR /home/{{ server_user }}

CMD cd /home/{{ server_user }} \
  && curl https://ci.nodejs.org/jnlpJars/slave.jar -O \
  && java -Xmx{{ server_ram|default('128m') }} \
          -jar /home/{{ server_user }}/slave.jar \
          -jnlpUrl {{ jenkins_url }}/computer/{{ item.name }}/slave-agent.jnlp \
          -secret {{ item.secret }}
