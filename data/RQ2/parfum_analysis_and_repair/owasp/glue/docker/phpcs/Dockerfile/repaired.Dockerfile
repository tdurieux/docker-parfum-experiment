FROM ubuntu:14.04
MAINTAINER Matt Konda <mkonda@jemurai.com>
# Environment
RUN apt-get update && apt-get install --no-install-recommends -y ruby ruby-dev nodejs openjdk-7-jre && rm -rf /var/lib/apt/lists/*;

# Pipeline App

# Working Dir
RUN mkdir /pipeline
WORKDIR /pipeline

# Core Pipeline
RUN git clone https://github.com/owasp/pipeline.git
RUN gem install bundler
RUN bundle install -j20


# Java Based Tools
# Dependency Check
RUN mkdir /depcheck
WORKDIR /depcheck
RUN wget https://dl.bintray.com/jeremy-long/owasp/dependency-check-1.3.1-release.zip
RUN unzip dependency-check-1.3.1-release.zip

# ZAP
RUN mkdir /zap
WORKDIR /zap
RUN wget https://github.com/zaproxy/zaproxy/releases/download/2.4.2/ZAP_2.4.2_Linux.tar.gz /zap
RUN tar -zxvf /zap/*.gz

# Node JS Tools
