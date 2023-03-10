FROM node:11.10

# Set a working directory
COPY . /web
WORKDIR /web

# Install native dependencies
RUN yarn install --no-cache --frozen-lockfile --production && yarn cache clean;

ENTRYPOINT ["./docker-entrypoint.sh"]
