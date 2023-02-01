FROM python:3.9

WORKDIR /usr/src/app

COPY Pipfile /usr/src/app
COPY Pipfile.lock /usr/src/app/Pipfile.lock

RUN pip install --no-cache-dir pipenv
RUN pipenv install
