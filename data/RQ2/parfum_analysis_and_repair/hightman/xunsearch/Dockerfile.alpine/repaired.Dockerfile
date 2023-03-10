# 基于Alpine镜像去构建
FROM alpine:3.13

# 设定时区和工作目录
ENV TZ Asia/Shanghai
WORKDIR /usr/local/xunsearch

# 安装迅搜
RUN apk add --no-cache \
    tzdata \
    zlib-dev \
    libgcc \
    libstdc++ \
    && apk add --no-cache --virtual .build-deps \
    wget \
    bzip2 \
    make \
    g++ \
    gcc \
    && wget -qO - https://www.xunsearch.com/download/xunsearch-full-latest.tar.bz2 | tar xj \
    && cd xunsearch-full-* && sh setup.sh --prefix=/usr/local/xunsearch \
    && cd .. && rm -rf xunsearch-full-* && apk del .build-deps && rm -rf /var/cache/apk/*

# 暴露端口
EXPOSE 8383
EXPOSE 8384

#启动脚本
COPY docker-entrypoint.sh docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh

CMD ["./docker-entrypoint.sh"]