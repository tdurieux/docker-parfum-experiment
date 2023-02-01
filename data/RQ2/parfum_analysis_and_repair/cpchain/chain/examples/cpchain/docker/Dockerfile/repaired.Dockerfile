# Docker container spec for building the cpchain blockchain explorer
#
# VERSION               0.0.1

FROM ubuntu:16.04
LABEL maintainer="chengx@cpchain.io"

# set location
ENV TZ 'Asia/Shanghai'
RUN echo $TZ > /etc/timezone

RUN apt-get update; apt-get -y upgrade; apt-get -y --no-install-recommends install locales tzdata && rm -rf /var/lib/apt/lists/*;

WORKDIR /
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/Alex-Cheng/explorer
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;

# A workaround for a bug, want: nodejs -> node
RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN npm config set registry https://registry.npm.taobao.org
RUN npm install -g bower && npm cache clean --force;
WORKDIR /explorer
RUN npm install && npm cache clean --force;
RUN bower install --allow-root

CMD  /bin/sh -c "cd /explorer && npm start"

EXPOSE 8000

# run `
#   docker tag <image id> cpchain_blockchain_explorer:latest
# ` to tag the docker image.
