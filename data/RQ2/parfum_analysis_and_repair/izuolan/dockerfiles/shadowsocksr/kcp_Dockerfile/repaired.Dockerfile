FROM alpine:3.4

RUN if [ $(wget -qO- ipinfo.io/country) == CN ]; then echo "http://mirrors.ustc.edu.cn/alpine/v3.4/main/" > /etc/apk/repositories ;fi  \
    && apk update && apk add --no-cache ca-certificates wget && update-ca-certificates

RUN downloadurl=`wget -qO- https://github.com/xtaci/kcptun/releases | sed -n 's/.*href="\([^"]*\).*/\1/p' | grep -m 1 linux-amd64` \
    && wget -q "https://github.com""$downloadurl" -O kcptun && tar -xf kcptun -C /usr/bin && rm kcptun