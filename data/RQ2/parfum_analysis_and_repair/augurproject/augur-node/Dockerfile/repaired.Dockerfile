FROM node:10.15 as builder

WORKDIR /app/

COPY wait-for-url.sh wait-for-url.sh
COPY config.json config.json
COPY tsconfig.json tsconfig.json
COPY certs certs

COPY package.json package.json
RUN git init && npm install --verbose && rm -rf .git && npm cache clean --force;

COPY src src
COPY test test
RUN npm run build:ts
RUN npm pack

COPY knexfile.js knexfile.js

FROM node:10.15
EXPOSE 9001
WORKDIR /app/
COPY --from=builder /app/node_modules node_modules

COPY --from=builder /app/augur-node*.tgz /app
RUN tar xzf augur-node*.tgz && mv package/* . && rm -rf package && rm augur-node*.tgz

COPY docker-entrypoint.sh docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]
