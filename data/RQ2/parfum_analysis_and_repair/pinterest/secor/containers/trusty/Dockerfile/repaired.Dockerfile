FROM ubuntu:trusty

RUN apt-get update && \
  apt-get -y --no-install-recommends install git make maven openjdk-7-jdk ruby s3cmd wget && \
  gem install fakes3 -v 0.1.7 && rm -rf /var/lib/apt/lists/*;

ENV SECOR_LOCAL_S3 true

WORKDIR /work
