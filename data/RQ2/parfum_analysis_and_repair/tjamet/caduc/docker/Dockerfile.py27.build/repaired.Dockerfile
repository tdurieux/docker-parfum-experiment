FROM python:2.7-alpine

RUN apk update && apk add --no-cache git

RUN pip install --no-cache-dir pyinstaller==3.1.1

ADD requirements.txt /tmp/requirements.txt
ADD requirements-dev.txt /tmp/requirements-dev.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt -r
