FROM python:3.9-slim-buster

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN apt-get update \
    # dependencies for building Python packages \
    && apt-get install --no-install-recommends -y build-essential \
    && apt-get install --no-install-recommends -y texlive \
    && apt-get install --no-install-recommends -y texlive-latex-extra \
    && apt-get install --no-install-recommends -y dvipng \
    && apt-get install --no-install-recommends -y python3-sphinx \
    # Translations dependencies
    && apt-get install --no-install-recommends -y gettext \
    # cleaning up unused files
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

# Copy the application
COPY . /app

RUN pip install --no-cache-dir --no-input Sphinx sphinx-autobuild sphinx-rtd-theme \
    && pip install --no-cache-dir -r app/docs/requirements.txt \
    && pip install --no-cache-dir /app

WORKDIR /app/docs/
