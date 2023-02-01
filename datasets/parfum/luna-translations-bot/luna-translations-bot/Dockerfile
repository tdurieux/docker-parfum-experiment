FROM node:16-alpine

# install build deps
RUN apk add python3 py3-pip build-base

# install deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

# build ts files
COPY ./src ./src
COPY tsconfig.json ./
RUN npm run tsc

CMD ["node", "./build/index.js"]
