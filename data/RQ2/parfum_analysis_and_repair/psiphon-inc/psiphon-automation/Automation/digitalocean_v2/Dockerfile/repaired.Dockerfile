# Dokcerfile made to test this
FROM python:alpine

MAINTAINER Lorenzo Setale <lorenzo@setale.me>

RUN pip3 install --no-cache-dir -U python-digitalocean pytest

WORKDIR /root/
ADD . /root/python-digitalocean

WORKDIR /root/python-digitalocean
RUN pip3 install --no-cache-dir -U -r requirements.txt

CMD python3 -m pytest