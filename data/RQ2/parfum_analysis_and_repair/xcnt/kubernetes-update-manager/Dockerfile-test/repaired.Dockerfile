FROM golang:1.18-alpine

RUN apk add --no-cache --update git alpine-sdk bash build-base
RUN go install github.com/tebeka/go2xunit@latest && \
    go install golang.org/x/lint/golint@latest && \
    go install github.com/t-yuki/gocover-cobertura@latest && \
    go install github.com/swaggo/swag/cmd/swag@v1.8.1 && \
    go install github.com/golang/mock/mockgen@v1.6.0
WORKDIR /app

ENV GOFLAGS -mod=vendor
ADD . /app
RUN make generate_swagger
