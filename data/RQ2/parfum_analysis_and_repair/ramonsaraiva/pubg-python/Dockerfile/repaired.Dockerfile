FROM python:3.7-alpine3.10

ADD . /code
WORKDIR /code

ADD requirements /requirements
RUN pip install --no-cache-dir -r /requirements/test.txt
