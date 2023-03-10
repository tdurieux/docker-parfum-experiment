# pull official base image
FROM node:14-alpine

# set working directory
WORKDIR /usr/src/app

# Install git
RUN apk add --no-cache git

# add `/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY packages/generic/core/package.json ./packages/generic/core/
COPY packages/generic/client/package.json ./packages/generic/client/
COPY yarn.lock ./
RUN yarn install --pure-lockfile && yarn cache clean;

# add app
COPY . .

# build the app
RUN yarn compileClient

# start app
CMD ["yarn", "startLocalClient"]
