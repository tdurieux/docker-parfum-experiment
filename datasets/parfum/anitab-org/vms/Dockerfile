FROM python:3.6
MAINTAINER Tapasweni Pathak <tapaswenipathak@gmail.com>
EXPOSE 8000

WORKDIR /usr/src
RUN mkdir vms
RUN cd vms
WORKDIR /usr/src/vms
COPY requirements.txt /usr/src/vms/requirements.txt
RUN pip install -r requirements.txt

