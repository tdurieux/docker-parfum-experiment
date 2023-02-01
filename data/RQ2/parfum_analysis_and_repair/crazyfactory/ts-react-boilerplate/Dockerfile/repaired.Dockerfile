FROM mhart/alpine-node:latest

MAINTAINER Crazy Factory dev@crazy-factory.com

WORKDIR /app
ADD . .

RUN npm install && npm cache clean --force;

EXPOSE 8889

CMD ["npm", "run", "start:prod"]
