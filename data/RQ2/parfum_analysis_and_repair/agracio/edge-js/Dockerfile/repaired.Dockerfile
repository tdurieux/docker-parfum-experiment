FROM ubuntu:focal

# update apt-get
RUN apt-get -y update

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;

# install curl, sudo, wget
RUN apt-get install --no-install-recommends -y curl sudo wget && rm -rf /var/lib/apt/lists/*;

RUN mkdir /devvol
VOLUME /devvol

RUN apt-get -y update

# install dependencies
RUN apt-get install --no-install-recommends -y apt-transport-https build-essential libgconf-2-4 python git libglib2.0-dev && rm -rf /var/lib/apt/lists/*;

# install node

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN sudo apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# install net core

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN sudo dpkg -i packages-microsoft-prod.deb
RUN sudo apt-get update
RUN sudo apt-get install --no-install-recommends -y dotnet-sdk-5.0 && rm -rf /var/lib/apt/lists/*;

RUN npm i -g node-gyp && npm cache clean --force;