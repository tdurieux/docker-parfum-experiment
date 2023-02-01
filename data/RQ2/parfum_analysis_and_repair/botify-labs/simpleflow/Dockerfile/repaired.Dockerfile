# Development Dockerfile; see README.rst
FROM python:2.7
MAINTAINER labs@botify.com

RUN curl -f -s https://bootstrap.pypa.io/get-pip.py | python -
RUN mkdir /code

ADD . /code/simpleflow

WORKDIR /code/simpleflow

RUN pip install --no-cache-dir .
RUN pip install --no-cache-dir -r requirements-dev.txt
RUN python setup.py develop
