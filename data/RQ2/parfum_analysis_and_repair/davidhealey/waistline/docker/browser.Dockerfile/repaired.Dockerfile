FROM alpine:3

# Install dependencies
RUN apk add --no-cache --update nodejs npm
RUN npm install -g cordova && npm cache clean --force;

# Because some commands ask if we want to opt in
RUN cordova telemetry off

# Create app directory
WORKDIR /usr/src/

# Do this every time the container is run
CMD ["./docker/browser.start.sh"]
