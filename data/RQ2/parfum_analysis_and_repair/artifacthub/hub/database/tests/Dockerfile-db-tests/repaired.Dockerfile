# Build tern
FROM golang:1.18-alpine3.15 AS tern
RUN apk --no-cache add git
RUN go get -u github.com/jackc/tern

# Build final image