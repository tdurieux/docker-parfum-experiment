FROM python:2-jessie

MAINTAINER Scalyr Inc <support@scalyr.com>


WORKDIR /tmp

RUN git init && \
  git config --local user.name "Scalyr" && git config --local user.email support@scalyr.com && \
  git clone -b master git://github.com/scalyr/scalyr-agent-2.git

RUN pip install --no-cache-dir mock==2.0.0
RUN chmod -R +x scalyr-agent-2
WORKDIR scalyr-agent-2
