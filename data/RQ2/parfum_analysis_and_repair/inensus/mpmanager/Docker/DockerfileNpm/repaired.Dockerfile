FROM node:14.3

WORKDIR /home/node/app

COPY configuration/npm/start.sh /tmp/start.sh
RUN chmod +x /tmp/start.sh