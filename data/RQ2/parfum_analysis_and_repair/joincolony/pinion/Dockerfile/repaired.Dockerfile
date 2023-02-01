FROM node:10.16.3-jessie-slim AS builder

ADD . / pinion/

RUN apt-get update && apt-get install --no-install-recommends -y python build-essential curl file zip && rm -rf /var/lib/apt/lists/*;

RUN cd /pinion && yarn && yarn build && rm -rf node_modules && yarn --production

FROM node:10.16.3-jessie-slim

COPY --from=builder /pinion /pinion

RUN cd /pinion

ENTRYPOINT /pinion/bin/index.js
