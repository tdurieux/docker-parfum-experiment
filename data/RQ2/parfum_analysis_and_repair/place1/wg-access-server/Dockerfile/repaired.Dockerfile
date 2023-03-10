### Build stage for the website frontend
FROM node:10 as website
RUN apt-get update && apt-get install --no-install-recommends -y protobuf-compiler libprotobuf-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /code
COPY ./website/package.json ./
COPY ./website/package-lock.json ./
RUN npm ci --no-audit --prefer-offline
COPY ./proto/ ../proto/
COPY ./website/ ./
RUN npm run codegen
RUN npm run build

### Build stage for the website backend server
FROM golang:1.13.8-alpine as server
RUN apk add --no-cache gcc musl-dev
RUN apk add --no-cache protobuf
RUN apk add --no-cache protobuf-dev
WORKDIR /code
ENV GOOS=linux
ENV GARCH=amd64
ENV CGO_ENABLED=1
ENV GO111MODULE=on
RUN go get github.com/golang/protobuf/protoc-gen-go@v1.3.5
COPY ./go.mod ./
COPY ./go.sum ./
RUN go mod download
COPY ./proto/ ./proto/
COPY ./codegen.sh ./
RUN ./codegen.sh
COPY ./main.go ./main.go
COPY ./cmd/ ./cmd/
COPY ./pkg/ ./pkg/
COPY ./internal/ ./internal/
RUN go build -o wg-access-server

### Server
FROM alpine:3.10
RUN apk add --no-cache iptables
RUN apk add --no-cache wireguard-tools
RUN apk add --no-cache curl
ENV WG_CONFIG="/config.yaml"
ENV WG_STORAGE="sqlite3:///data/db.sqlite3"
COPY --from=server /code/wg-access-server /usr/local/bin/wg-access-server
COPY --from=website /code/build /website/build
CMD ["wg-access-server", "serve"]
