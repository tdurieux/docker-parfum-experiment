FROM python:3.6
MAINTAINER denzow <denzow@gmail.com>

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8

WORKDIR /app

RUN pip install --no-cache-dir -v pip-tools==1.9.0

ADD ./requirements.txt requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt
