FROM python:3.7

ADD . /code
WORKDIR /code

RUN pip install --no-cache-dir -U pip wheel pipenv && \
    pipenv install
