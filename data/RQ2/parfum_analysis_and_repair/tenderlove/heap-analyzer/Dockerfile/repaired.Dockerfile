FROM node:alpine AS builder

RUN npm install -g bower && apk add --no-cache git && npm cache clean --force;

WORKDIR /app
ADD . /app

RUN bower --allow-root install

FROM nginx:alpine
COPY --from=builder /app /usr/share/nginx/html
