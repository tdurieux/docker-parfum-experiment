ARG PYVERSION=3.6
FROM python:${PYVERSION}-alpine

RUN apk add --no-cache curl git build-base
ENV DOCKERVERSION=19.03.5
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && mv docker-${DOCKERVERSION}.tgz docker.tgz \
  && tar xzvf docker.tgz \
  && mv docker/docker /usr/local/bin \
  && rm -r docker docker.tgz

ADD requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

ADD test /opt/test
ADD example /opt/example
