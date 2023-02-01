FROM node:lts-alpine AS builder
ADD gui /gui
WORKDIR /gui
RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;

FROM nginx:stable-alpine
COPY --from=builder /web /usr/share/nginx/html
EXPOSE 80
