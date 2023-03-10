FROM node:alpine as builder

WORKDIR /app

COPY package.json ./
COPY package-lock.json ./

RUN npm install && npm cache clean --force;

COPY . ./

RUN npm run build

FROM golang:1.16-alpine as server-builder
RUN apk add --no-cache build-base

WORKDIR /server

COPY server/go.mod ./
COPY server/go.sum ./

RUN go mod download

COPY server/*.go ./

RUN GOOS=linux GOARCH=amd64 go build -ldflags '-linkmode=external' -o frontend-server .

FROM alpine

COPY --from=builder /app/build ./build
COPY --from=server-builder /server/frontend-server ./

EXPOSE 5000

ENTRYPOINT ["./frontend-server"]
