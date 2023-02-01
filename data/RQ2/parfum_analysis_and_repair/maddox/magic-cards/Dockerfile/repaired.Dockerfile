FROM resin/raspberry-pi-alpine-node:9.11.2

RUN npm install yarn -g && npm cache clean --force;
RUN npm install concurrently -g && npm cache clean --force;

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN script/docker/setup

EXPOSE 5000
CMD [ "script/stack" ]
