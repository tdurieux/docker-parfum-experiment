FROM python:3.7

COPY . /ovisbot

WORKDIR /ovisbot

RUN pip install --no-cache-dir pipenv
RUN pipenv install -e .