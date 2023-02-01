FROM ubuntu:trusty

#install nodejs v4.x
RUN apt-get upgrade -yq
RUN sudo rm /var/lib/apt/lists/* -rvf
RUN sudo apt-get update -y
RUN apt-get install --no-install-recommends -yq \
    curl \
    git \
    build-essential \
    python-software-properties \
    python \
    g++ \
    make \
    nano && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN sudo apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install npm -g && npm cache clean --force;
RUN node -v && npm -v

#prepare tools
RUN npm install -g \
    bunyan \
    nodemon \
    gulp \
    pm2 \
    webpack && npm cache clean --force;
