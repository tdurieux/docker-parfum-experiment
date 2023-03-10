FROM node:12.13-alpine

WORKDIR /data/main

# confirm installation
RUN node -v
RUN npm -v

#install pm2 to production (monitoring)
RUN npm install pm2 -g && npm cache clean --force;
#install nodemon to dev (support hot realoading) (need specific command in compose)
RUN npm install nodemon -g && npm cache clean --force;

# install tool for npm lib compile in C
RUN apk add --update --no-cache autoconf libtool automake python alpine-sdk

# Install app dependencies
COPY ./main/package.json /data/

RUN cd /data/ && npm cache clean --force && npm install --loglevel verbose && npm cache clean --force;

# add src & build configuraiton
COPY ./core /data/core/
COPY ./main /data/main/

COPY ./wait-for-it.sh /data/scripts/

# Expose ports (for orchestrators and dynamic reverse proxies)
EXPOSE 8080

CMD [ "pm2-runtime", "app.js", "--name" ,"main"]
