FROM python:3.9-slim

RUN pip install --no-cache-dir platformio

COPY build.sh /build.sh

ENTRYPOINT ["/build.sh"]