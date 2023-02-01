# base
FROM python:3.9-slim-buster AS base
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
RUN apt-get update && apt-get install --no-install-recommends -y \
    gcc && rm -rf /var/lib/apt/lists/*;
ADD requirements.txt /app/
ADD ./requirements/ /app/requirements/
RUN pip install --no-cache-dir -r /app/requirements.txt


# test (server)
FROM base AS test-server
ENV QUART_APP camus:create_app()
ENV QUART_ENV development
RUN pip install --no-cache-dir -r /app/requirements/test.txt
ADD . /app


# dev
FROM base AS dev
ENV QUART_APP camus:create_app()
ENV QUART_ENV development
RUN apt-get update && apt-get install --no-install-recommends -y \
    vim && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r /app/requirements/dev.txt
ADD . /app
