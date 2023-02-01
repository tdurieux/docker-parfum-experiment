FROM python:3.7-slim

RUN useradd -ms /bin/bash worker \
    && apt-get update \
    && apt-get install -y git netcat
COPY requirements.txt /requirements.txt
RUN python3 -m pip install -U pip setuptools \
    && python3 -m pip install -U -r /requirements.txt

USER worker
WORKDIR /home/worker
ENV PYTHONPATH="${PYTHONPATH}:${HOME}"

EXPOSE 5000 5050
