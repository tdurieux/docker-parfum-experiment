FROM node:latest

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/

RUN yarn && yarn cache clean;

COPY . /usr/src/app

ENV CLIENT_ID pJ2VRJzLBwBitL6ZJoiXOLeamCxRs8Bw
RUN yarn run build && yarn cache clean;
EXPOSE 3000

CMD [ "yarn", "start" ]
