FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV QT_QPA_PLATFORM=offscreen

RUN apt-get update -qq && apt-get install --no-install-recommends -qq -y build-essential nodejs npm git ruby-dev && rm -rf /var/lib/apt/lists/*;

ADD . /arethusa
WORKDIR /arethusa

RUN npm install -g grunt-cli bower && npm install && npm cache clean --force;
RUN grunt install && grunt import
