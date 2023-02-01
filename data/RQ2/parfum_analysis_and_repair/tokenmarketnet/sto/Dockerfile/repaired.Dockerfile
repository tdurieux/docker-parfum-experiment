# https://github.com/jfloff/alpine-python
#

#
# Release:
#
# docker login --username=miohtama
# docker tag miohtama/sto:latest miohtama/sto:0.1
# docker push miohtama/sto:latest
# docker push miohtama/sto:0.1
#


FROM jfloff/alpine-python:3.6
MAINTAINER Mikko Ohtamaa <mikko@tokenmarket.net>
ADD . /myapp
WORKDIR /myapp
RUN apk add --no-cache libffi-dev openssl-dev sqlite-dev
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -e .

ENTRYPOINT ["sto"]