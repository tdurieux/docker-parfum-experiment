FROM python:2.7

RUN apt-get update && apt-get install --no-install-recommends -y openssl curl && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir requests

WORKDIR /sut

ADD test /sut/
