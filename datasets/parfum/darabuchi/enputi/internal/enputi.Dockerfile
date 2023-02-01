FROM golang:1.17.1 as build

MAINTAINER darabuchi <darabuchi0818@gmail.com>
WORKDIR /home/

ENV GOPROXY=https://goproxy.cn,direct
ENV GOSUMDB=off
ENV GO111MODULE=on

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN apt-get update && apt-get install upx -y

RUN go install -v github.com/goreleaser/goreleaser@latest

RUN curl -L -o /home/GeoLite2.mmdb https://kutt.luoxin.live/GHfTBv
RUN curl -L -o /home/clash.tpl https://cdn.jsdelivr.net/gh/darabuchi/enputi@master/resource/clash.tpl
RUN curl -L -o /home/.enputi.es https://kutt.luoxin.live/EiFhJq
RUN curl -L -o /home/config.yaml https://kutt.luoxin.live/3v4DWp

COPY .. /home/enputi/

WORKDIR /home/enputi/

RUN go mod tidy -compat=1.17 && go run -v ./tool/sync.go -b --disable-key-hook -t enputi
RUN #upx -9vf --ultra-brute /home/enputi/dist/*/*

FROM scratch
WORKDIR /root/
COPY --from=build /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /home/enputi/dist/enputi_linux_amd64/enputi /root/
#COPY --from=build /home/enputi/enputi /root/
COPY --from=build /home/GeoLite2.mmdb /root/resource/GeoLite2.mmdb
COPY --from=build /home/clash.tpl /root/resource/clash.tpl
COPY --from=build /home/config.yaml /root/config.yaml

ENTRYPOINT ["/root/enputi", "-c", "/root/config.yaml"]
