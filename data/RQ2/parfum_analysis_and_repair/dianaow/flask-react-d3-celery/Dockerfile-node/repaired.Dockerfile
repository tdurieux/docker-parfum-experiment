# base image
FROM mhart/alpine-node:6

RUN apk add --update bash && rm -rf /var/cache/apk/*

# set working directory
WORKDIR /home/ubuntu/celery-scheduler
ENV PATH /home/ubuntu/celery-scheduler/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json /home/ubuntu/celery-scheduler/package.json
RUN npm install --silent && npm cache clean --force;
