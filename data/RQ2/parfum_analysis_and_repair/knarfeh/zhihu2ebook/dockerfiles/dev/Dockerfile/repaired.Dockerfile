FROM python:3.6.0rc2-alpine
MAINTAINER He Jun knarfeh@outlook.com

# base pkgs
RUN apk --update add --no-cache openssl

# build pkgs
RUN apk --update --no-cache add gcc g++ python3-dev musl-dev make

# dev pkgs
RUN apk add --no-cache curl

COPY requirements /requirements
RUN mkdir -p /var/log/zhihueebook
RUN pip3 install --no-cache-dir -U pip \
    && pip install --no-cache-dir -i https://pypi.douban.com/simple -r requirements/dev.txt

WORKDIR /src