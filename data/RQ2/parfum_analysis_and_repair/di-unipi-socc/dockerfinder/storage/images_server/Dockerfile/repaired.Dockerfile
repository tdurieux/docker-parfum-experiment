FROM node:alpine
# node.js and npm already installed

# Create  directory that store the source code
RUN mkdir -p /code
WORKDIR /code

#install git because it is needed otinstall node-restful lates release
RUN apk add --no-cache --update git


# Install server dependencies
COPY package.json /code
RUN npm install -save && npm cache clean --force;

COPY . /code

ENTRYPOINT  ["npm","start"]
