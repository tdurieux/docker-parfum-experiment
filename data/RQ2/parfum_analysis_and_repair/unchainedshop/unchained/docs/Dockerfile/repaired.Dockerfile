FROM node:12-slim

ENV NODE_ENV production
ENV GATSBY_TELEMETRY_DISABLED 1
ENV BRANCH master

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
COPY package-lock.json /usr/src/app/
RUN NODE_ENV=development npm install && npm cache clean --force;

# Build app
COPY . /usr/src/app/

RUN npm run api-docs
RUN npm run build

EXPOSE 9000

CMD npm run start
