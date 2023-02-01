# base image
FROM node:13.5.0-stretch

RUN apt-get update && apt-get install -y yarn

# set working directory
RUN mkdir /app
WORKDIR /app

ENV PORT 3000

# install and cache app dependencies
COPY . /app
RUN npm config set registry https://neo.jfrog.io/neo/api/npm/npm/
RUN yarn install
EXPOSE 3000

ENV PATH /app/node_modules/.bin:$PATH

# start app
CMD ["/usr/local/bin/yarn", "start"]
