FROM node:16-alpine

WORKDIR /opt/service

# update all OS dependencies to prevent vuln's
RUN apk update && apk upgrade apk-tools

# Copy PJ, changes should invalidate entire image
COPY package.json yarn.lock /opt/service/

# Copy commong typings
COPY typings /opt/service/typings

# Copy TS configs
COPY tsconfig* /opt/service/

# Build backend
COPY src /opt/service/src

# Build Frontend
COPY webpack.*.js README.md /opt/service/

COPY tools /opt/service/tools

# Install dependencies
RUN yarn --cache-folder ../ycach && NODE_ENV=production yarn build && yarn --production --cache-folder ../ycache && rm -rf ../ycache && rm -rf src && rm -rf tools && rm -rf typings && yarn cache clean;

ENV NODE_ENV=production

EXPOSE 8080

ENTRYPOINT ["npm", "run", "start", "--"]
