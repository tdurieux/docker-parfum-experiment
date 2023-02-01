##########################################
# Dockerfile to run Pegasus
# Based on Debian
###########################################
FROM debian:jessie

MAINTAINER Austin Ouyang

RUN apt-get update \
    && apt-get install --no-install-recommends -y vim \
    && apt-get install --no-install-recommends -y openssh-client \
    && apt-get install --no-install-recommends -y python \
    && apt-get install --no-install-recommends -y python-dev \
    && apt-get install --no-install-recommends -y python-pip \
    && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir awscli

RUN git clone https://github.com/sstephenson/bats.git /root/bats

RUN /root/bats/install.sh /usr/local

ENV PEGASUS_HOME /root/pegasus
ENV PATH $PEGASUS_HOME:$PATH
ENV REM_USER ubuntu

COPY . /root/pegasus

RUN echo "source pegasus-completion.sh" >> /root/.bashrc

WORKDIR /root

