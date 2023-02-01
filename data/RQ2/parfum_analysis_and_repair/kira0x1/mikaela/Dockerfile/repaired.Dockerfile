FROM node:16-slim as builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 \
    build-essential \
    make \
    libtool-bin \
    g++ && rm -rf /var/lib/apt/lists/*;

WORKDIR /mikaela
COPY ["package.json", "yarn.lock", "./"]

RUN npm install -g npm@latest node-gyp && npm cache clean --force;
RUN yarn

##### RUNNER #####
FROM node:16-slim

WORKDIR /mikaela

COPY package.json package.json
COPY --from=builder /mikaela/node_modules node_modules

COPY . .

RUN npx tsc

CMD ["yarn", "start"]