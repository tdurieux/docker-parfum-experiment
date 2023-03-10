FROM node:10-alpine as builder
WORKDIR app
COPY ./ /app
RUN yarn && yarn build && yarn cache clean;

FROM nginx:alpine as runtime
COPY --from=builder /app/dist /usr/share/nginx/html
