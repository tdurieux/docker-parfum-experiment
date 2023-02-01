FROM node:12.15.0-alpine AS websocket-gateway-service-builder
WORKDIR /home/service/websocket-gateway-service
COPY . .
RUN yarn install --frozen-lockfile && yarn cache clean;
RUN yarn run build

FROM node:12.15.0-alpine
ENV NODE_ENV=production
WORKDIR /home/service/websocket-gateway-service
COPY --from=websocket-gateway-service-builder /home/service/websocket-gateway-service/build ./build
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --no-cache --production && yarn cache clean;
CMD yarn start