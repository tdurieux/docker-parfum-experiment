FROM node:12.18.4-alpine as builder

# A directory within the virtualized Docker environment
# where we will copy the source code
WORKDIR /usr/src/app

# Copies package.json and package-lock.json to Docker environment
COPY package.json ./
COPY yarn.lock ./
COPY *.json ./
COPY *.js ./

# Install workspace dependencies
RUN yarn

# Copy packages over to Docker environment
COPY ./packages/ ./packages/

RUN yarn policies set-version 1.18.0 && yarn cache clean;

# Build it all
RUN yarn && yarn build

# => Run container
FROM nginx:1.19.2-alpine

# Nginx config
COPY ./proxy/default.conf /etc/nginx/templates/default.conf.template

# Static build
COPY --from=builder /usr/src/app/packages/webapp/build/ /var/www/

# Default port exposure
EXPOSE 3000
