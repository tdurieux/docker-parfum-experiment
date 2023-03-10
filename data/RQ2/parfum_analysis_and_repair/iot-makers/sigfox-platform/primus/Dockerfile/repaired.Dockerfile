FROM node:14-alpine
RUN apk add --no-cache curl

EXPOSE $PORT
HEALTHCHECK --interval=10s --timeout=2s --retries=3 \
  CMD curl --silent --fail "http://localhost:$PORT/primus?access_token=healthcheck&transport=polling" || exit 1

WORKDIR /primus
COPY package*.json /primus/
COPY yarn.lock /primus/
RUN yarn --frozen-lockfile
COPY ./ /primus/