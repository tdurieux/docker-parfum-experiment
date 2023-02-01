# build the angular app
FROM node:16 AS build
WORKDIR /usr/src/app
RUN apt-get update && apt-get install --no-install-recommends -y \
  libudev-dev \
  libusb-1.0-0-dev && rm -rf /var/lib/apt/lists/*;
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run wallet:build

# build the nginx hosting container
FROM nginx:1.21-alpine
COPY .docker/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /usr/src/app/dist /usr/share/nginx/html