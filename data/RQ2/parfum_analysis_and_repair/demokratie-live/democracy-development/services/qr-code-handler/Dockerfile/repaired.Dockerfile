FROM node:12-alpine AS BUILD_IMAGE

# install next-optimized-images requirements
RUN apk --no-cache update \ 
    && apk --no-cache add yarn curl bash python \
    &&  rm -fr /var/cache/apk/*

# install node-prune (https://github.com/tj/node-prune)
RUN curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin

WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn --frozen-lockfile && yarn cache clean;
COPY . .

RUN yarn build && yarn cache clean;

RUN npm prune --production

# run node prune
RUN /usr/local/bin/node-prune

FROM node:12-alpine

WORKDIR /app

COPY . .

# copy from build image
COPY --from=BUILD_IMAGE /app/built ./built
COPY --from=BUILD_IMAGE /app/node_modules ./node_modules

ENV NODE_ENV=production

ENTRYPOINT [ "yarn", "start" ]