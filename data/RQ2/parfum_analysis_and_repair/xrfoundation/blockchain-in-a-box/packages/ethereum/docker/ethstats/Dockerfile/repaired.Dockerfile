FROM node:6-alpine
MAINTAINER Kyle Bai <kyle.b@inwinstack.com>

RUN apk add --no-cache git g++ make bash && \
  git clone https://github.com/cubedro/eth-netstats /ethstats && \
  cd /ethstats && \
  npm install && \
  npm install -g grunt-cli && \
  grunt && \
  npm cache clear --force && \
  apk del --no-cache git make g++ && \
  rm -f /var/cache/apk/* && \
  npm cache clear --force

COPY entrypoint.sh /usr/local/bin/

WORKDIR /ethstats
EXPOSE 3000/tcp

ENTRYPOINT ["entrypoint.sh"]
