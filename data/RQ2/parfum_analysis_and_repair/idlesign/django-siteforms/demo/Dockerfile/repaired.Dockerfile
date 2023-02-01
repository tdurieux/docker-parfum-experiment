FROM python:3.7-alpine

ADD . /code
WORKDIR /code

ADD requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt