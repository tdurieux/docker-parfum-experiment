# Pull base image
FROM python:3.10-buster as builder

# Set environment variables
COPY requirements.txt requirements.txt

# Install pipenv
RUN set -ex && pip install --no-cache-dir --upgrade pip

# Install dependencies
RUN set -ex && pip install --no-cache-dir -r requirements.txt
RUN set -ex && pip install --no-cache-dir rdkit-pypi==2021.9.4

FROM builder as final
WORKDIR /source
COPY ./app /source/
COPY ./tests /source/
COPY .env /source/
