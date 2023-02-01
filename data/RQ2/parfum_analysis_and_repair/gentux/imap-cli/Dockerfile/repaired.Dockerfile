FROM python:3.6

MAINTAINER Romain Soufflet <romain@soufflet.io>

RUN pip install --no-cache-dir tox twine wheel

ADD . /src
WORKDIR /src

RUN python setup.py develop
