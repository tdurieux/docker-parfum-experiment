FROM node:0.12
MAINTAINER Darin London <darin.london@duke.edu>

RUN apt-get -qq update && apt-get install --no-install-recommends -y \
  git \
  curl && rm -rf /var/lib/apt/lists/*;

RUN npm install -g git+https://github.com/SparkPost/api-blueprint-validator.git#44a81cadb99f5e3ec74284a63a34263a4d7cce6 aglio cheerio htmlparser2 && npm cache clean --force;

ENV NODE_PATH /usr/local/lib/node_modules
RUN ["mkdir","-p","/var/www"]
WORKDIR /var/www/app
