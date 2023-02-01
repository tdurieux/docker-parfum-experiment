###
# Copyright (c) 2015-2019 Mainflux
#
# Mainflux is licensed under an Apache license, version 2.0 license.
# All rights not explicitly granted in the Apache license, version 2.0 are reserved.
# See the included LICENSE file for more details.
###

# Stage 0, based on Node.js, to build and compile Elm app
FROM node:10.15.1-alpine as builder

WORKDIR /app
RUN npm install --unsafe-perm=true --allow-root -g elm

COPY . /app
RUN elm make --optimize src/Main.elm --output=main.js

# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM arm32v7/nginx:1.16
COPY --from=builder /app/index.html /usr/share/nginx/html
COPY --from=builder /app/main.js /usr/share/nginx/html
COPY --from=builder /app/css/mainflux.css /usr/share/nginx/html/css/
COPY --from=builder /app/src/Websocket.js /usr/share/nginx/html/src/
COPY --from=builder /app/docker/nginx.conf /etc/nginx/conf.d/default.conf
