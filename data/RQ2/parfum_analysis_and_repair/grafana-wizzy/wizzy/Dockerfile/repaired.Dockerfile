FROM node:8.6-alpine
MAINTAINER Utkarsh Bhatnagar <utkarsh.cmu@gmail.com>
ADD . /app
WORKDIR /app
RUN npm install && npm cache clean --force;
RUN npm link
ENTRYPOINT /bin/ash
