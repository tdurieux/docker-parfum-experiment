FROM node:lts-alpine

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json yarn.* ./

RUN yarn && yarn cache clean;
RUN yarn cache clean && yarn cache clean;

# Bundle app source
COPY . .

CMD [ "yarn", "start" ]
