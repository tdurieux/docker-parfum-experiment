FROM python:3.7-buster

WORKDIR /usr/src/app

ADD . .

RUN apt-get update && \
    apt-get -y --no-install-recommends install pipenv && rm -rf /var/lib/apt/lists/*;

RUN pipenv install --dev

ENV PYTHONPATH src/main/python
