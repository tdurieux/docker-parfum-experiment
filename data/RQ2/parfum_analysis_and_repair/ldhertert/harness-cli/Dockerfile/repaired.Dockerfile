FROM node:12-alpine

WORKDIR /usr/src/harness-cli

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

RUN npm run build

RUN npm link

# First run seems slow, so try to run it here
RUN harness --version

ENTRYPOINT [ "harness" ]
