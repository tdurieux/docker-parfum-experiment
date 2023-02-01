FROM python:3.7.2

RUN apt-get update && apt-get install -y cmake bison flex

ENV PYTHONPATH=/usr/src/app/

WORKDIR /usr/src/app

COPY . /usr/src/app/

RUN make init
RUN pip install -e .[test]