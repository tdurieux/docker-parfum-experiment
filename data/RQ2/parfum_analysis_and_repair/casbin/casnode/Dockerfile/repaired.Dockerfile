FROM golang:1.17 AS BACK
WORKDIR /go/src/casnode
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOPROXY=https://goproxy.cn,direct go build -ldflags="-w -s" -o server . \
    && apt update && apt install -y --no-install-recommends wait-for-it && chmod +x /usr/bin/wait-for-it && rm -rf /var/lib/apt/lists/*;

FROM node:14.17.6 AS FRONT
WORKDIR /web
COPY ./web .
RUN yarn config set registry https://registry.npmmirror.com && yarn cache clean;
RUN yarn install && yarn run build && yarn cache clean;

FROM alpine:latest
RUN sed -i 's/https/http/' /etc/apk/repositories
RUN apk add --no-cache curl
LABEL MAINTAINER="https://casnode.org/"

COPY --from=BACK /go/src/casnode/ ./
COPY --from=BACK /usr/bin/wait-for-it ./
RUN mkdir -p web/build && apk add --no-cache bash coreutils
COPY --from=FRONT /web/build /web/build
CMD ./wait-for-it db:3306 -- ./server