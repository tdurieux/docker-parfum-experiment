FROM alpine:3.15

ARG TZ="Asia/Shanghai"
ENV TZ ${TZ}

RUN apk upgrade --update
RUN apk --update --no-cache add tzdata
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime

ADD build/gohangout /usr/local/bin/gohangout
