ARG app_port

FROM node:12-alpine as builder
RUN npm install -g typescript && npm cache clean --force;
RUN mkdir -p /app/server
WORKDIR /app/server
COPY . /app/server
RUN npm install && npm cache clean --force;
RUN npm run-script build
RUN rm -rf node_modules
RUN npm install --production && npm cache clean --force;

FROM node:12-alpine

RUN mkdir -p /app/server
WORKDIR /app/server
COPY --from=builder /app/server/creds creds
COPY --from=builder /app/server/apidoc.yaml ./apidoc.yaml
COPY --from=builder /app/server/README.md ./README.md
COPY --from=builder /app/server/Makefile ./Makefile
COPY --from=builder /app/server/package.json ./package.json
COPY --from=builder /app/server/node_modules node_modules
COPY --from=builder /app/server/logs logs
COPY --from=builder /app/server/dist dist

EXPOSE $app_port
EXPOSE $debug_port
CMD [ "npm", "start" ]
