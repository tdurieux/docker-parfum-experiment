FROM ghcr.io/toltec-dev/python:v1.1

RUN pip3 install --no-cache-dir okp

WORKDIR /rmkit
COPY . /rmkit/
RUN rm src/build -fr
