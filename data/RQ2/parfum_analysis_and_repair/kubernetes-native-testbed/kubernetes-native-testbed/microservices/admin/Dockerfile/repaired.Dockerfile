FROM node:12 as builder
WORKDIR /app
COPY admin/package.json ./
COPY admin/yarn.lock ./
RUN yarn install && yarn cache clean;
COPY admin/webpack.config.js ./
COPY admin/src/ ./src/
RUN yarn run webpack && yarn cache clean;

FROM nginx:1.17
COPY --from=builder /app/public/bundle.js /usr/share/nginx/html/
COPY admin/public/ /usr/share/nginx/html/
