FROM node:18-alpine as builder
COPY . /app/
WORKDIR /app
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN npm config set registry https://registry.npmmirror.com
RUN npm i -g pm2 @nestjs/cli pnpm
RUN apk --no-cache add bash
RUN bash build-output.sh

FROM node:18-alpine as prod
ENV TZ=Asia/Shanghai
COPY --from=builder /app/docker/* /app/docker/
COPY --from=builder /app/output/ /app/

WORKDIR /app
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN npm config set registry https://registry.npmmirror.com
RUN set -x \
    && apk update \
    && apk add --no-cache tzdata redis  \
    && chmod +x /app/docker/start.sh \
    && npm i -g pm2 @nestjs/cli pnpm \
    && rm -rf /var/cache/apk/*

ENTRYPOINT sh /app/docker/start.sh
