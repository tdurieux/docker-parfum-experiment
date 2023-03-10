FROM node:alpine

# Create app directory
RUN mkdir -p /code/<%= dir %>
WORKDIR /code/<%= dir %>

# Set environment variable
ENV NODE_ENV production

# Install app dependencies
COPY package.json /code/<%= dir %>/
RUN apk add --no-cache --virtual .app-deps python make g++ \
  && yarn --pure-lockfile \
  && yarn cache clean \
  && apk del .app-deps && yarn cache clean;

# Bundle app source
COPY . /code/<%= dir %>

# Port
EXPOSE <%= port %>

# Start
CMD [ "yarn", "start" ]
