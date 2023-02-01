FROM  node:16-alpine
WORKDIR /usr/src/ssb-bot-feed
RUN apk add --no-cache python3 build-base libtool autoconf automake
COPY . .
ENV NODE_ENV production
RUN npm install -g npm@latest && npm cache clean --force;
RUN npm install --no-save && npm cache clean --force;
ENTRYPOINT ["./index.js"]
