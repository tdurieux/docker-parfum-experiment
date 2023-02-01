FROM ubuntu:focal

# update apt-get
RUN apt-get -y update

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y apt-utils

# install curl, sudo, wget
RUN apt-get install -y curl sudo wget

RUN mkdir /devvol
VOLUME /devvol

RUN apt-get -y update

# install dependencies
RUN apt-get install -y apt-transport-https build-essential libgconf-2-4 python git libglib2.0-dev

# install node

RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN sudo apt-get install -y nodejs

# install net core

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN sudo dpkg -i packages-microsoft-prod.deb
RUN sudo apt-get update
RUN sudo apt-get install -y dotnet-sdk-5.0

RUN npm i -g node-gyp