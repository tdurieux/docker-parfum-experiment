FROM node:16.2.0-alpine AS builder
WORKDIR /app
COPY package.json package.json
RUN npm install && npm cache clean --force;

FROM golang:1.17 as ethereum
RUN apt update && apt install --no-install-recommends jq -y && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
RUN go get -d github.com/ethereum/go-ethereum@v1.10.8 \
&& go install github.com/ethereum/go-ethereum/cmd/abigen@v1.10.8 \
&& go install github.com/mattn/goveralls@v0.0.11 \
&& go install github.com/ory/go-acc@v0.2.7 \
&& go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.44.2

COPY --from=builder /app/node_modules node_modules
COPY . .
RUN make setup
