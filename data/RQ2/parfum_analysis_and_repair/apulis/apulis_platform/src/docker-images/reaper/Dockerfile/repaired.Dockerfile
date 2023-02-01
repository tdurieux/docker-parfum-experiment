FROM python:3.7

RUN pip3 install --no-cache-dir requests flask

WORKDIR /reaper

COPY * /reaper/
