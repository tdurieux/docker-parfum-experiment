FROM xylix/node-aurelia:latest as builder

WORKDIR /build
# Npm dependency lists get imported separately to let docker cache the
# npm install
COPY package-lock.json package.json /build/
RUN npm install && npm cache clean --force;

COPY . .
ARG env=dev
RUN au build --env $env

from nginx:mainline-alpine
COPY --from=builder /build /usr/share/nginx/html
