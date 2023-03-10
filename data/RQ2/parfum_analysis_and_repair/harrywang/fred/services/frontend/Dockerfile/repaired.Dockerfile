# pull official base image
FROM node:13.5.0-alpine

# set working directory
WORKDIR /usr/src/fred

# add `/usr/src/fred/node_modules/.bin` to $PATH
ENV PATH /usr/src/fred/node_modules/.bin:$PATH

# --no-cache: download package index on-the-fly, no need to cleanup afterwards
# --virtual: bundle packages, remove whole bundle at once, when done
RUN apk update
RUN apk --no-cache --virtual build-dependencies add \
    python \
    make \
    g++

# install and cache app dependencies
COPY package.json /usr/src/fred/package.json
COPY package-lock.json /usr/src/fred/package-lock.json
RUN npm ci
RUN npm install react-scripts@3.4.0 -g --silent && npm cache clean --force;

# remove whole bundle at once, when done
RUN apk del build-dependencies

# start app
CMD ["npm", "start"]
