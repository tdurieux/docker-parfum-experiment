# Dockerfile for Pipenv wrapper
# Unfortunately it seems not possible to reuse the Django Dockerfile, as not installing any packages in it
# will result in all .build-deps apks being deleted from it and pipenv failing to lock/install
# The build steps of this file are taken from the Django Dockerfile to make the build a bit faster though.

FROM python:{{ cookiecutter.python_version }}-alpine3.8

VOLUME /src
WORKDIR /src

# Install bash, libpq{% if cookiecutter.include_cms == 'yes' %}, libjpeg-turbo{% endif %} and gettext
RUN apk add --no-cache bash gettext libpq{% if cookiecutter.include_cms == 'yes' %} libjpeg-turbo{% endif %}

# Install build dependencies and mark them as virtual packages so they could be removed together
RUN apk add --no-cache --virtual .build-deps \
    ca-certificates alpine-sdk postgresql-dev python3-dev linux-headers musl-dev \
    libffi-dev libxml2-dev libxslt-dev jpeg-dev zlib-dev

# Copy Python requirements dir and Install requirements
RUN pip install -U pipenv==2018.11.26 pip setuptools wheel
