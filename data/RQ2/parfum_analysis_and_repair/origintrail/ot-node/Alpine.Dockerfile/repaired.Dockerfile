FROM node:14-alpine3.15

LABEL maintainer="OriginTrail"
ENV NODE_ENV=testnet

#Install Papertrail
RUN wget https://github.com/papertrail/remote_syslog2/releases/download/v0.20/remote_syslog_linux_amd64.tar.gz
RUN tar xzf ./remote_syslog_linux_amd64.tar.gz && cd remote_syslog && cp ./remote_syslog /usr/local/bin && rm ./remote_syslog_linux_amd64.tar.gz

COPY config/papertrail.yml /etc/log_files.yml

#Install nodemon, git & forever
RUN npm install forever -g && npm cache clean --force;
RUN apk add --no-cache git

WORKDIR /ot-node

COPY . .

#Install nppm
RUN npm install && npm cache clean --force;



