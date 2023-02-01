FROM node:6.10.2-alpine

# Install Redis
RUN apk add --no-cache --virtual redis

# Create app directory
RUN mkdir -p /usr/src/humix && rm -rf /usr/src/humix
WORKDIR /usr/src/humix

# Bundle app source
COPY . /usr/src/humix
RUN npm install && npm cache clean --force;

RUN mkdir /data && chown redis:redis /data
VOLUME /data

EXPOSE 3000
CMD [ "./bin/start.sh" ]
