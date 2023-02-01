# Build Stage
FROM golang:1.16 AS build-stage
ADD ./ /latte
RUN cd /latte && env GOOS=linux GOARCH=amd64 go build -tags postgresql ./cmd/latte

# Final Stage