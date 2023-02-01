FROM python:3

RUN pip install --no-cache-dir bs4
RUN pip install --no-cache-dir urllib5
RUN pip install --no-cache-dir http3


WORKDIR /data
