FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV QT_QPA_PLATFORM=offscreen

RUN apt-get update -qq && apt-get install -qq -y build-essential nodejs npm git ruby-dev

ADD . /arethusa
WORKDIR /arethusa

RUN npm install -g grunt-cli bower && npm install
RUN grunt install && grunt import
