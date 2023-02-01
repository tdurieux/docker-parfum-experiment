# The building of ProtoBuf "messages" must be done out of Docker because grpc-node does not ship with ARM64 binaries.
# See: https://github.com/grpc/grpc-node/issues/1405
# When the issue above is closed, we can move back messages building inside Dockerfile

# protobuf build
#FROM node:14.18.2-buster-slim@sha256:20bedf0c09de887379e59a41c04284974f5fb529cf0e13aab613473ce298da3d as proto-builder
#WORKDIR /usr/src
#COPY messages/yarn.lock messages/package.json ./
#RUN yarn install
#COPY messages .
#RUN yarn proto

# typescript build
FROM node:16.15-buster-slim@sha256:9ad2f889d4a15ef94e40ac75e95c28daa34073dbc25d7b1e619caacc6b83623c as builder
WORKDIR /usr/src
COPY map-storage/yarn.lock map-storage/package.json ./
RUN yarn install
COPY map-storage .
#COPY --from=proto-builder /usr/src/generated src/Messages/generated
ENV NODE_ENV=production
RUN yarn run build

# final production image
FROM node:16.15-buster-slim@sha256:9ad2f889d4a15ef94e40ac75e95c28daa34073dbc25d7b1e619caacc6b83623c
WORKDIR /usr/src
COPY map-storage/yarn.lock map-storage/package.json ./
ENV NODE_ENV=production
RUN yarn install --production
COPY --from=builder /usr/src/dist /usr/src/dist

USER node
CMD ["yarn", "run", "start:prod"]
