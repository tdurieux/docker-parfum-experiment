FROM golang:1.16 AS go

WORKDIR /data
ADD . .
RUN make build

FROM node:lts-buster AS node

WORKDIR /data
ADD . .
RUN npm install && npm cache clean --force;
RUN npm run build

FROM alpine

WORKDIR /data
COPY --from=go /data/bin/pstbin /usr/bin/pstbin
COPY --from=node /data/dist /data/dist

CMD ["pstbin"]
