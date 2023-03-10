FROM python:3.7
ENV PYTHONUNBUFFERED 1

MAINTAINER mtianyan <1147727180@qq.com>

ADD ./requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com \
    && pip install --no-cache-dir uwsgi -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8000

WORKDIR /PROJECT_ROOT