# build stage
FROM golang:alpine as backend-builder
RUN apk --no-cache add ca-certificates
ENV GO111MODULE=on
WORKDIR /app
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build cmd/torq/torq.go

# frontend build stage
FROM node:lts-alpine as frontend-builder
WORKDIR /app
COPY web/package*.json ./
RUN npm install
COPY web/. .
RUN npm run build

# final stage
FROM alpine
COPY --from=backend-builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=backend-builder /app/torq /app/
COPY --from=frontend-builder /app/build /app/web/build
RUN apk add --no-cache bash
ENV GIN_MODE=release
WORKDIR /app
ENTRYPOINT ["./torq"]
