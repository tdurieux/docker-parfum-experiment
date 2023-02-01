FROM golang:1.17.1 as build

MAINTAINER darabuchi <darabuchi0818@gmail.com>
WORKDIR /home/

ENV GOPROXY=https://goproxy.cn,direct
ENV GOSUMDB=off
ENV GO111MODULE=on

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN apt-get update && apt-get install upx -y

RUN go install -v github.com/goreleaser/goreleaser@latest

COPY .. /home/enputi/

WORKDIR /home/enputi/

RUN go mod tidy -compat=1.17 && go run -v ./tool/sync.go -b --disable-key-hook -t mini-enputi
#RUN upx -9vf --ultra-brute /home/enputi/dist/*/*

FROM scratch
WORKDIR /root/
COPY --from=build /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /home/enputi/dist/mini-enputi_linux_amd64/mini-enputi /root/

ENTRYPOINT ["/root/mini-enputi" ,"-s", "https://api.luoxin.live/api/enputi/sub/v2ray", "-auto", "-w", "2005"]
