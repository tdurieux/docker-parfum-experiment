# builder image
FROM node AS builder
ARG api

WORKDIR ${api}
COPY ${api}package.json .
RUN npm install && npm cache clean --force;
COPY ${api} .

RUN npm run build

# build production image
FROM node:alpine
ARG api
RUN npm install -g serve && npm cache clean --force;

WORKDIR /app
COPY --from=builder ${api}/build/ .
ENTRYPOINT ["serve", "-l", "tcp://0.0.0.0:80"]