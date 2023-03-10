FROM python:3.7

ENV PYTHONUNBUFFERED 1

RUN mkdir /code
WORKDIR /code
COPY . /code/

RUN pip install --no-cache-dir poetry
RUN poetry config virtualenvs.create false
RUN poetry install
