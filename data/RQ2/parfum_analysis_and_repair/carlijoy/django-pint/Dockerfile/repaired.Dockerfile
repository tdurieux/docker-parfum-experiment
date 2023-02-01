FROM python:3.8-slim

# install system dependencies

RUN apt-get update && apt-get install --no-install-recommends -y build-essential libpq-dev curl gettext git postgresql-client && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade wheel setuptools pip

RUN pip3 install --no-cache-dir pre-commit psycopg2-binary ipdb

WORKDIR /django-pint

# copy application files
COPY . /django-pint

RUN pre-commit install

RUN pip install --no-cache-dir -e '.[testing]'
