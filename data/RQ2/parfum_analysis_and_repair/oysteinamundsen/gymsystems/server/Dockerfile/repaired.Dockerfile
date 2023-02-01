FROM node:11.4-alpine as dist
WORKDIR /tmp/
# Setup builder system
RUN apk add --no-cache python make g++

# Copy source and install
COPY src src/
COPY package.json ./
RUN yarn install && yarn cache clean;

COPY tsconfig.json ormconfig.js ./
RUN yarn build
RUN rm -rf node_modules
RUN yarn install --production && yarn cache clean;

FROM node:11.4-alpine
WORKDIR /usr/local/nub-api
COPY --from=dist /tmp/ ./
ENV NODE_PATH ./dist:./node_modules
EXPOSE 3000
CMD ["yarn", "start:prod"]
