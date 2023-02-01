FROM python:3.7-alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
COPY requirements.txt /tmp/requirements.txt

# install system packages
RUN apk update && apk add --no-cache \
    build-base \
    musl-dev \
    python3-dev \
    linux-headers \
    pcre-dev \
&& pip install --no-cache-dir --upgrade pip \
&& pip install --no-cache-dir -r /tmp/requirements.txt -i https://mirrors.aliyun.com/pypi/simple \
&& apk del \
    build-base \
    musl-dev \
&& rm -rf /tmp/*

CMD ["uwsgi", "--ini", "/etc/uwsgi/uwsgi.ini"]