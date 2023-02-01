FROM python:3.7-slim-buster

ENV PYTHONWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update \
  # dependencies for building Python packages \
  && apt-get install --no-install-recommends -y build-essential \
  # psycopg2 dependencies
  && apt-get install --no-install-recommends -y libpq-dev \
  # Translations dependencies
  && apt-get install --no-install-recommends -y gettext \
  # cleaning up unused files
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/*

# Requirements are installed here to ensure they will be cached.
COPY ./requirements /requirements
RUN pip install --no-cache-dir -r /requirements/development.txt

COPY ./docker/development/start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /app
