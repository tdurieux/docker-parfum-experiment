FROM node:lts-slim AS node-builder
WORKDIR /src/node
COPY package.json .
COPY yarn.lock .
RUN yarn && yarn cache clean;
COPY next.config.js .
COPY tsconfig.json .
COPY public ./public
COPY src ./src
RUN yarn build && yarn cache clean;
RUN yarn export && yarn cache clean;

FROM golang:alpine AS golang-builder
RUN go env -w GO111MODULE=on
WORKDIR /src/golang
COPY go/go.mod go/go.sum ./
RUN go mod download
COPY go/. .
COPY --from=node-builder /src/node/out ./out
RUN go build -tags headless -o mongood .

FROM alpine
ENV PORT=3000
EXPOSE 3000
COPY --from=golang-builder /src/golang/mongood /usr/local/bin/mongood
CMD ["/usr/local/bin/mongood"]
