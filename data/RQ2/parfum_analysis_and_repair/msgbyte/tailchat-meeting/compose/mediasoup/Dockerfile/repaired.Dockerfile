FROM node:16-buster-slim

WORKDIR /tailchat-meeting

RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free" > /etc/apt/sources.list
RUN apt-get update && apt install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

ADD ./sources.list /etc/apt/

RUN apt-get update && \
    apt-get install --no-install-recommends -y git bash jq build-essential python python3-pip openssl libssl-dev pkg-config && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN echo "registry = https://registry.npmmirror.com" > ~/.npmrc
RUN npm install -g pnpm && npm cache clean --force;
RUN npm install -g mediasoup@3.9.10 && npm cache clean --force;
ENV MEDIASOUP_WORKER_BIN=/usr/local/lib/node_modules/mediasoup/worker/out/Release/mediasoup-worker
