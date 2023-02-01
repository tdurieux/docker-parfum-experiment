FROM frolvlad/alpine-glibc

RUN apk update && apk upgrade && apk add --no-cache bash && apk add --no-cache tzdata

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

COPY bin/gravity-operator-amd64 /gravity-operator