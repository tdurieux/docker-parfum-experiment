FROM node:8.9.0

WORKDIR /root/app
RUN curl https://install.meteor.com/ | sh
RUN curl -SLO "https://github.com/lair-framework/lair/releases/download/v2.5.0/lair-v2.5.0-linux-amd64.tar.gz" \
    && tar -zxf lair-v2.5.0-linux-amd64.tar.gz \
    && cd bundle/programs/server \
    && npm i

COPY ./package.json /root/app/bundle/programs/server/package.json

ENV ROOT_URL=http://0.0.0.0
ENV PORT 11014
ENV MONGO_URL=mongodb://database:27017/lair
ENV MONGO_OPLOG_URL=mongodb://database:27017/local
EXPOSE 11014
CMD cd /root/app/bundle/programs/server && meteor npm start
