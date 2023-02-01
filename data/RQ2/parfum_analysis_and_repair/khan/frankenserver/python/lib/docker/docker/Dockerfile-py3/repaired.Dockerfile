FROM python:3.4
MAINTAINER Joffrey F <joffrey@docker.com>

RUN mkdir /home/docker-py
WORKDIR /home/docker-py

ADD requirements.txt /home/docker-py/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

ADD test-requirements.txt /home/docker-py/test-requirements.txt
RUN pip install --no-cache-dir -r test-requirements.txt

ADD . /home/docker-py
RUN pip install --no-cache-dir .
