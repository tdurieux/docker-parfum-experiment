FROM node:16.9.0

WORKDIR /amongst
ADD . .

# Need to yarn install in order to have esbuild
RUN yarn install --immutable && yarn cache clean;

RUN yarn build && yarn cache clean;
RUN yarn build-client && yarn cache clean;
WORKDIR /amongst/packages/server
CMD ["yarn", "start"]
