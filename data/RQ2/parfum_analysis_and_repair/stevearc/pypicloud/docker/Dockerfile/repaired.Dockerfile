FROM ubuntu:20.04
MAINTAINER Steven Arcangeli <stevearc@stevearc.com>

RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -yqq \
    python3-pip python3-dev libldap2-dev libsasl2-dev \
    libmysqlclient-dev libffi-dev libssl-dev default-jre curl git \
  && pip3 install --no-cache-dir --upgrade pip \
  && pip3 install --no-cache-dir --upgrade setuptools tox && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://raw.githubusercontent.com/fkrull/docker-multi-python/master/setup.sh -o /setup.sh \
  && bash setup.sh \
  && rm /setup.sh
