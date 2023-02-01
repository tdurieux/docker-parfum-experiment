FROM ubuntu:trusty

RUN apt-get update \
  && apt-get -y upgrade \
  && apt-get -y --no-install-recommends install \
    curl wget build-essential rbenv ruby ruby-dev unzip git && rm -rf /var/lib/apt/lists/*;
