# Stage 1 - build
FROM node:16.14.0-alpine3.15 as build

## Install build toolchain, install node deps and compile native add-ons
RUN apk add --no-cache python3 make g++

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

RUN yarn install --production && yarn cache clean;

RUN cp -R node_modules prod_node_modules

RUN yarn install && yarn cache clean;

COPY . .

RUN yarn build-frontend && yarn cache clean;

RUN yarn compile && yarn cache clean;

# Stage 2 - make final image
FROM node:16.14.0-alpine3.15

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
COPY --from=build /usr/src/app/prod_node_modules ./node_modules
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/public ./public

ENV NODE_ENV=production

CMD ["node", "dist/bin/server.js"]
