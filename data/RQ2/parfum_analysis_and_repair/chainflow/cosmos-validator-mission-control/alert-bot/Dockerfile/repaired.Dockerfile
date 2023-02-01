# Stage 1
FROM golang:1.13.1 AS builder

COPY . /app/chainflow-vitwit/alert-bot

WORKDIR /app/chainflow-vitwit/alert-bot

RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o /main .


# Stage 2