FROM python:3.8-alpine
ENV PYTHONUNBUFFERED 1

RUN apk add --no-cache bash
RUN apk add --no-cache vim
RUN apk add --no-cache redis
RUN apk add --no-cache build-base

RUN mkdir /stats_tracker
WORKDIR /stats_tracker

ADD stats_tracker ./stats_tracker
ADD tests ./tests/

ADD requirements.txt ./
ADD requirements_test.txt ./
ADD requirements_dev.txt ./

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements_test.txt
RUN pip install --no-cache-dir -r requirements_dev.txt

CMD redis-server