FROM golang:1.18 AS build_base
LABEL maintainer="chenjiayao <chenjiayaooo@gmail.com>"
WORKDIR /tmp/godeng

COPY . .

RUN go env -w GO111MODULE=on
RUN go env -w GOPROXY=https://goproxy.cn,direct
RUN go mod tidy

# RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-X cmd.VERSION=v1.0.0" -o bin/godeng cmd/main.go
RUN CGO_ENABLED=0 GOOS=linux go build  -o bin/godeng cmd/main.go

FROM alpine:3.14

WORKDIR /app

COPY --from=build_base /tmp/godeng/example/example.json /app/config.json
COPY --from=build_base /tmp/godeng/bin/godeng /app/godeng

CMD ["/app/godeng", "--config=/app/config.json", "--sleep=1", "--loop"]