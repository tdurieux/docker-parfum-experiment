FROM python:alpine

RUN apk -U upgrade
RUN pip install --no-cache-dir dirbpy

ENTRYPOINT [ "dirbpy" ]