FROM arm32v6/python:3.8-alpine3.12

VOLUME /config

COPY . /
RUN python setup.py develop

WORKDIR /
ENTRYPOINT ["python", "/usr/local/bin/enoceanmqtt", "/enoceanmqtt-default.conf", "/config/enoceanmqtt.conf"]