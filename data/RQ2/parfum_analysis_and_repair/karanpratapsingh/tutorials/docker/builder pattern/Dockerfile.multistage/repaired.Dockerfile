FROM golang:1.16.5 as builder
WORKDIR /app
COPY go.mod .
COPY main.go .
RUN go build -o app

FROM alpine:latest as production
COPY --from=builder app .
EXPOSE 8080
CMD ./app