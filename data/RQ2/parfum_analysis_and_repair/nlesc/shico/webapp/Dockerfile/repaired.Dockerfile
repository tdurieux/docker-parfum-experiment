FROM node:alpine

COPY . /home/shico
WORKDIR /home/shico

RUN apk update && apk add --no-cache git

RUN npm install -g gulp bower && npm cache clean --force;
RUN npm install . && npm cache clean --force;
RUN bower install --config.interactive=false --allow-root

CMD /home/shico/dockerRun.sh
