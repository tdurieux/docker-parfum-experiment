
FROM golang:1.18.0-alpine AS Builder

RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories
ENV GOPROXY=https://proxy.golang.com.cn,direct

RUN apk add git build-base

WORKDIR /usr/src/xfsgo

COPY go.mod go.sum ./ 

RUN go mod download -x && go mod verify

COPY . .
RUN go build -a -o xfsgo .

FROM golang:1.18.0-alpine


COPY --from=Builder /usr/src/xfsgo/xfsgo /usr/local/bin

WORKDIR /etc/xfsgo

EXPOSE 9011
EXPOSE 9012
ENTRYPOINT [ "xfsgo", "daemon" ]

CMD [ "-r", "0.0.0.0:9012" ]
