FROM node:10.16-alpine

LABEL maintainer="Ryo Ota <nwtgck@gmail.com>"

RUN apk add --no-cache tini

COPY . /app

# Move to /app
WORKDIR /app

# Install requirements, build and remove devDependencies
# (from: https://stackoverflow.com/a/25571391/2885946)
RUN npm install && \
    npm run build && \
    npm prune --production

# Run a server
ENTRYPOINT [ "tini", "--", "node", "dist/src/index.js" ]
