FROM python:3.9-slim-bullseye

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

# # Requirements are installed here to ensure they will be cached.
COPY /requirements /requirements

# All imports needed for autodoc.
RUN pip install --no-cache-dir -r /requirements/docs.txt -r

COPY docker/docs/start /start-docs
RUN sed -i 's/\r$//g' /start-docs
RUN chmod +x /start-docs

WORKDIR /docs