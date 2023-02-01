# Pull base image
FROM python:3.10-slim-buster as builder

# Set environment variables
COPY requirements.txt requirements.txt

# Install pipenv
RUN set -ex && pip install --no-cache-dir --upgrade pip

# Install dependencies
RUN set -ex && pip install --no-cache-dir -r requirements.txt

FROM builder as final
WORKDIR /code
COPY ./the_app/ /code/
COPY ./tests/ /code/
COPY .env /code/

RUN set -ex && bash -c "eval $(grep 'PYTHONDONTWRITEBYTECODE' .env)"
RUN set -ex && bash -c "eval $(grep 'PYTHONUNBUFFERED' .env)"
