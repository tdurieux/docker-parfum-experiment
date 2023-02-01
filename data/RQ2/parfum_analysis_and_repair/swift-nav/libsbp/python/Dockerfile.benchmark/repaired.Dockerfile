FROM python:3.7-slim-buster

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install --no-install-recommends -y git llvm-7-dev build-essential && rm -rf /var/lib/apt/lists/*;

WORKDIR /work
ADD . /work

RUN pip3 install --no-cache-dir -r /work/setup_requirements.txt
RUN pip3 install --no-cache-dir -r /work/requirements.txt

RUN pip3 install --no-cache-dir wheel setuptools

RUN pip3 install --no-cache-dir '.[sbp2json]'
