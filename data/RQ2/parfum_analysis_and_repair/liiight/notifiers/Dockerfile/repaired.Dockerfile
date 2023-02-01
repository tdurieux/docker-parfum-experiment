FROM python:alpine3.7

ADD . /notifiers
WORKDIR /notifiers

RUN pip install --no-cache-dir -e .

ENTRYPOINT ["notifiers"]