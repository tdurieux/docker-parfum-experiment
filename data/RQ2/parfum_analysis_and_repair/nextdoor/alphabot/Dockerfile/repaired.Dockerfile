FROM python:3-onbuild

MAINTAINER Mikhail Simin

COPY ./ /app/

RUN pip install --no-cache-dir -e /app
