FROM ubuntu:16.04

## General package configuration
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install \
        sudo \
        unzip \
        zip \
        curl \
        xmlstarlet \
        netcat-traditional \
        software-properties-common \
        debconf-utils \
        ncurses-bin \
        iputils-ping \
        net-tools \
        apt-transport-https \
        git \
        jq && rm -rf /var/lib/apt/lists/*;

## Install Java
RUN \
  add-apt-repository -y ppa:openjdk-r/ppa  && \
  apt-get update && \
  apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;


# add GPG key
RUN curl -f "https://bintray.com/user/downloadSubjectPublicKey?username=bintray" > /tmp/bintray.gpg.key
RUN apt-key add - < /tmp/bintray.gpg.key

#Install Rundeck CLI tool
RUN echo "deb https://dl.bintray.com/rundeck/rundeck-deb /" | sudo tee -a /etc/apt/sources.list
RUN curl -f "https://bintray.com/user/downloadSubjectPublicKey?username=bintray" > /tmp/bintray.gpg.key
RUN apt-key add - < /tmp/bintray.gpg.key
RUN apt-get -y --no-install-recommends install apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install rundeck-cli && rm -rf /var/lib/apt/lists/*;


RUN mkdir -p scripts data
COPY scripts scripts

RUN chmod -R a+x scripts/*

CMD scripts/run.sh