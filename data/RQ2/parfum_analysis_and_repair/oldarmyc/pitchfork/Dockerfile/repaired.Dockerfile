FROM python:2.7

MAINTAINER Dave Kludt

ADD . /pitchfork
WORKDIR /pitchfork

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
