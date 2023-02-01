FROM node:9-alpine

# Using this node version because `process.versions.modules` is 51, which
# matches the prebuilt `uws` binaries

RUN apk update && \
    apk add --no-cache git python g++ make

RUN npm i npm@latest -g && npm cache clean --force;

WORKDIR /app
COPY package* ./
COPY .eslint* .babel* ./

RUN npm install && npm cache clean --force;

COPY . .
COPY .env.sample .env

EXPOSE 3000

CMD ["npm", "run", "start"]
