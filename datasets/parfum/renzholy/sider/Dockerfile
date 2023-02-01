FROM node:16-slim AS node-builder
WORKDIR /src/node
COPY package.json .
COPY yarn.lock .
RUN yarn
COPY next.config.js .
COPY tsconfig.json .
COPY public ./public
COPY src ./src
RUN yarn build
RUN yarn export

FROM golang:alpine AS golang-builder
RUN go env -w GO111MODULE=on
WORKDIR /src/golang
COPY go/go.mod go/go.sum ./
RUN go mod download
COPY go/. .
COPY --from=node-builder /src/node/out ./out
RUN go build -tags headless -o sider .

FROM alpine
ENV PORT=3000
EXPOSE 3000
COPY --from=golang-builder /src/golang/sider /usr/local/bin/sider
CMD ["/usr/local/bin/sider"]
