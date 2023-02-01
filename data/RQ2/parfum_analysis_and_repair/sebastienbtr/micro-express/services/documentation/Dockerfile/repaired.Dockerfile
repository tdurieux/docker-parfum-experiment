FROM node:13
RUN curl -f -o- -L https://yarnpkg.com/install.sh | bash

WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean;
COPY . .