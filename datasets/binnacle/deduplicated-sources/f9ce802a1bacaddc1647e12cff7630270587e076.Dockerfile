FROM python:alpine

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app

RUN set -x \
  && pip install .

ENTRYPOINT ["cfn-cli"]
