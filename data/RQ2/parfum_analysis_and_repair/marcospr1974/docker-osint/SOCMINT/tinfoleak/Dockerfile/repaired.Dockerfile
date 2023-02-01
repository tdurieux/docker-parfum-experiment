FROM ubuntu:16.04

MAINTAINER Marcos Pablo Russo <marcospr1974@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends git curl build-essential \
    python-pip python-pil python-pyexiv2 python-openssl python-qt4 -y \
    && git clone https://github.com/vaguileradiaz/tinfoleak.git \
    && pip install --no-cache-dir tweepy exifread jinja2 oauth2 && rm -rf /var/lib/apt/lists/*;

WORKDIR /tinfoleak

ENTRYPOINT ["./tinfoleak.py"]
