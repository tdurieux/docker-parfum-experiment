# sra2json
FROM python:3.7

WORKDIR /tmp

RUN git clone https://github.com/seandavi/omicidx.git

WORKDIR /tmp/omicidx
RUN git pull origin master

RUN pip install --no-cache-dir .

RUN mkdir /data

WORKDIR /data
RUN rm -rf /tmp/omicidx

RUN pip install --no-cache-dir awscli google
