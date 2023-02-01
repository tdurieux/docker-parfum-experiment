FROM ubuntu:14.04

RUN apt-get update -y
RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update -y

RUN apt-get -y --no-install-recommends install curl build-essential ruby2.3 ruby2.3-dev dnsutils jq && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

RUN gem install cf-uaac --no-ri --no-rdoc

WORKDIR /usr/bin
RUN curl -f -L "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx
