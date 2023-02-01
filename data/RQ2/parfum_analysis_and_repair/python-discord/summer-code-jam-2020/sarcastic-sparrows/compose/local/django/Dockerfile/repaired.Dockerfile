FROM python:3.8-slim-buster

ENV PYTHONBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential \
    && apt-get install --no-install-recommends -y gettext \
    # Clean up unused files
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

COPY ./requirements /requirements
RUN pip install --no-cache-dir -r /requirements/local.txt

COPY ./compose/local/django/start /start
RUN sed -i 's/\r$//g' /start
RUN chmod +x /start

WORKDIR /code
