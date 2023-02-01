FROM python:3.5-slim

# Ensure that Python outputs everything that's printed inside
# the application rather than buffering it.
ENV PYTHONUNBUFFERED 1

RUN mkdir /code
WORKDIR /code

# Setup the locales in the Dockerfile
RUN set -x \
    && apt-get update \
    && apt-get install locales -y \
    && locale-gen en_US.UTF-8

# Install dependencies
RUN set -x \
    && apt-get install \
            wget \
            bzip2 \
            gcc \
            libpq-dev \
            libjpeg-dev \
            libffi-dev \
            libxml2-dev \
            libxslt1-dev \
            binutils \
            libproj-dev \
            gdal-bin \
            nodejs \
            git-core \
            --no-install-recommends -y \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Build Python virtualenv
ARG DJANGO_REQUIREMENTS
COPY ./requirements /code/requirements
RUN set -ex \
    && pip install -U virtualenv \
    && virtualenv /venv \
    && LIBRARY_PATH=/lib:/usr/lib /bin/sh -c "/venv/bin/pip install -r /code/requirements/$DJANGO_REQUIREMENTS.txt"

COPY . /code/

RUN /venv/bin/python /code/manage.py collectstatic --noinput

# CMD ["/code/compose/django/gunicorn.sh"]
