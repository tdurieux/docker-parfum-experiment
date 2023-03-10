FROM node:12.15.0-alpine AS admin-gateway-service-builder
WORKDIR /home/service/admin-gateway-service
COPY . .
RUN yarn install --frozen-lockfile && yarn cache clean;
RUN yarn run build && yarn cache clean;

FROM node:12.15.0-alpine
ENV NODE_ENV=production
WORKDIR /home/service/admin-gateway-service
COPY --from=admin-gateway-service-builder /home/service/admin-gateway-service/build ./build
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --no-cache --production && yarn cache clean;
CMD yarn start