FROM python:3.6.3
MAINTAINER Levi Stephen <levi.stephen@gmail.com>

ARG construi_version

COPY dist/construi-$construi_version.tar.gz /tmp/construi.tar.gz

RUN pip install --no-cache-dir /tmp/construi.tar.gz && rm /tmp/construi.tar.gz

ENTRYPOINT ["construi"]
