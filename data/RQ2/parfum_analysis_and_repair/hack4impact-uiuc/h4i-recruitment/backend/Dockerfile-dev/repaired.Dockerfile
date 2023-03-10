FROM node:12.9
WORKDIR /usr/src/app
# Copy over the module files separately so that they're cached as a build layer
# (i.e. no rebuild necessary if these don't change)
COPY package.json .
COPY yarn.lock .
RUN yarn && yarn cache clean;
COPY . .

