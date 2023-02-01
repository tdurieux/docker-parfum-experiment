# ===== Stage 1: Producing Build Files =====
FROM node:16.14.2-alpine AS build

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install && yarn cache clean;

COPY . .

# This outputs production-ready files to `build` in the current directory on the host
RUN yarn build

# ===== Stage 2: Setting up NGINX =====

FROM nginx:1.21.6-alpine

# From stage 1, copy the build files into the default directory that NGINX serves files from.
# The project will serve requests inbound at port 80 in the container
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

# We need to put in our own nginx config.
COPY nginx.conf /etc/nginx/nginx.conf

