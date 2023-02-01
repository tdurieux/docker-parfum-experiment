FROM ubuntu:latest

RUN mkdir /code
WORKDIR /code

env DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential python \
    python-dev python-pip && rm -rf /var/lib/apt/lists/*;

ENV PYTHONUNBUFFERED 1
ADD . /code

RUN pip install --no-cache-dir -r requirements.txt
