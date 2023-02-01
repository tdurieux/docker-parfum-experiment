#
# Build image
#
FROM node:16-alpine AS builder
ENV NODE_ENV production

# Install /app dependencies
WORKDIR /app
COPY package.json .
COPY yarn.lock .
RUN yarn install --production

# Copy app files & build
WORKDIR /app
COPY . .
RUN yarn build_docker

#
# Runtime image
#
FROM node:16-alpine as production
RUN apk add dumb-init
ENV NODE_ENV production
WORKDIR /usr/src/app
# Copy built assets from builder
COPY --chown=node:node --from=builder /app/ .
# Create and give permissions for app data
RUN mkdir -p /usr/src/data
RUN chmod ugo+rwx /usr/src/data
# Expose port
EXPOSE 5000
# Start IoT Center
USER node
CMD ["dumb-init", "yarn", "start"]
