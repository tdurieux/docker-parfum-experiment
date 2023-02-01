FROM node:10.11.0-alpine

# set working directory
RUN mkdir /usr/src && mkdir /usr/src/app
WORKDIR /usr/src/app

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json package-lock.json /usr/src/app/
RUN npm ci

COPY .eslintrc.json /usr/src/app/

# used for the tests in CircleCI
# is overwritten by the volume mounted in docker compose when running in dev/prod
COPY . /usr/src/app

# start app
CMD ["npm", "start"]
