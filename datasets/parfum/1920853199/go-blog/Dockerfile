
FROM golang:1.14.2-alpine3.11

ENV GOPROXY=https://goproxy.cn

WORKDIR /work

COPY . .

RUN go build -o go-blog main.go

CMD ./go-blog

EXPOSE 8080