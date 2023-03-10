FROM ubuntu:16.04
MAINTAINER toolbox@cloudpassage.com


ARG task
ENV raketask $task

RUN \
  apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y build-essential && \
  apt-get install -y --no-install-recommends zlib1g-dev && \
  apt-get install --no-install-recommends -y ruby ruby-dev ruby-bundler && \
  apt-get install --no-install-recommends -y openssh-server && \
  rm -rf /var/lib/apt/lists/*

COPY ./ /source/

WORKDIR /source/

RUN mkdir /root/.aws
RUN gem install rake -v 10.5.0

RUN bundle install
RUN gem install winrm -v 2.1.2
RUN gem install winrm-fs

CMD $raketask
