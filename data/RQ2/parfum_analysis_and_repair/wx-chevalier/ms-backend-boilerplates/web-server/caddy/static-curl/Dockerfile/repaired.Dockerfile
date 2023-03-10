FROM alpine:3.5
LABEL maintainer "Dragon <384924552@qq.com>"

LABEL caddy_version="0.10.3" architecture="amd64"

# 设置基本组件
ARG plugins=http.upload,http.cors,http.expires,http.filter,http.git,http.ipfilter,http.jwt,http.minify,http.proxyprotocol,http.ratelimit

# 安装基本应用
RUN apk add --no-cache openssh-client git tar curl

RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/linux/amd64?plugins=${plugins}" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
 && chmod 0755 /usr/bin/caddy \
 && /usr/bin/caddy -version

# 暴露接口
EXPOSE 80 2015

# 创建文件
RUN mkdir /opt/
RUN mkdir /opt/workspace
WORKDIR /opt/workspace

# 添加文件
ADD run.sh /opt/workspace
RUN chmod +x /opt/workspace/run.sh

ADD Caddyfile /etc/

ENTRYPOINT ["/opt/workspace/run.sh"]