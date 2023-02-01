FROM {{ $.source }}
LABEL maintainer="cookeem"
LABEL email="cookeem@qq.com"
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk --update --no-cache add git curl zip jq

# docker build -t {{ $.source }}-dory -f Dockerfile-alpine-{{ $.tagName }} .
