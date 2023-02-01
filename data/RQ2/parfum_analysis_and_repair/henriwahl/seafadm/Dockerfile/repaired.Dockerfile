FROM python:3

LABEL maintainer=h.wahl@ifw-dresden.de

ARG PIP_PROXY_ARG=''

RUN pip install --no-cache-dir $PIP_PROXY_ARG beautifulsoup4 psutil requests

WORKDIR /seafadm