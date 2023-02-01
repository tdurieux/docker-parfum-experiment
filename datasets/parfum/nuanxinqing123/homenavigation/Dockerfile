FROM amd64/golang:latest AS builder

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    GOPROXY=https://goproxy.cn,direct

MAINTAINER HomeNavigation "nuanxinqing@gmail.com"

WORKDIR $GOPATH/src/Gin_HomeNavigation

COPY . .

ADD . ./

#增加缺失的包，移除没用的包
RUN go mod tidy

RUN go build -o Gin_HomeNavigation .

FROM scratch

COPY --from=builder go/src/Gin_HomeNavigation/conf /conf
COPY --from=builder go/src/Gin_HomeNavigation/img /img
COPY --from=builder go/src/Gin_HomeNavigation/Gin_HomeNavigation /

ENTRYPOINT  ["./Gin_HomeNavigation"]