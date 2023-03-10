FROM alpine

#更新Alpine的软件源为国内源，提高下载速度
RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/main/" > /etc/apk/repositories

RUN apk update \
        && apk upgrade \
        && apk add --no-cache bash \
        bash-doc \
        bash-completion \
        && rm -rf /var/cache/apk/* \
        && /bin/bash
# 设置时区为上海
RUN apk -U --no-cache add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata


COPY /examples/simpleweb/app /
COPY /examples/simpleweb/config_dev.yml /


ENTRYPOINT ["/app"]