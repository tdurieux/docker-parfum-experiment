########
# This image compile the dependencies
########
FROM python:3.8-slim as compile-image

ENV VIRTUAL_ENV /srv/venv
ENV PATH "${VIRTUAL_ENV}/bin:${PATH}"
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

WORKDIR /srv

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends build-essential libpoppler-cpp-dev pkg-config git \
    && apt-get autoremove --purge -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN python -m venv ${VIRTUAL_ENV}

COPY requirements requirements
RUN pip install --no-cache-dir --upgrade pip uwsgi
RUN pip install --no-cache-dir -r requirements/tests.txt

########
# This image is the runtime
########
FROM python:3.8-slim as runtime-image

ARG VERSION_SHA
ARG VERSION_NAME
ENV VERSION_SHA $VERSION_SHA
ENV VERSION_NAME $VERSION_NAME

ENV VIRTUAL_ENV /srv/venv
ENV PATH "${VIRTUAL_ENV}/bin:${PATH}"
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV FLASK_APP fhir_api/app

WORKDIR /srv

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get autoremove --purge -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd uwsgi
RUN useradd --no-log-init -g uwsgi uwsgi
USER uwsgi

# Copy venv with compiled dependencies