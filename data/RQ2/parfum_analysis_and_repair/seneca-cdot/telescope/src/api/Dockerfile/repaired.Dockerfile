FROM node:lts-alpine

# Install pnpm
RUN npm i -g pnpm && npm cache clean --force;

# https://github.com/krallin/tini
RUN apk --no-cache add tini

# Set the entrypoint to user tini by default
ENTRYPOINT [ "/sbin/tini", "--"]

# Switch to the node user
USER node
