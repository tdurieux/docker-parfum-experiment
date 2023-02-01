FROM node:17-alpine

RUN mkdir /code
WORKDIR /code

COPY package.json yarn.lock gulpfile.js /code/
RUN yarn install && yarn cache clean;

COPY . /code/

# Run gulp to build static assets in image
RUN yarn build
