# syntax = docker/dockerfile:1.3
FROM debian:buster-slim as base

ARG UID
ENV UID=${UID:-9999}
ARG GID
ENV GID=${GID:-9999}

# We might be running as a user which already exists in this image. In that situation
# Everything is OK and we should just continue on.
RUN groupadd -g $GID baserow_docker_group || exit 0
RUN useradd --shell /bin/bash -u $UID -g $GID -o -c "" -m baserow_docker_user -l || exit 0
ENV DOCKER_USER=baserow_docker_user
ENV BASEROW_IMAGE_TYPE="backend"

RUN apt-get update &&  \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    gnupg2 \
    libpq-dev \
    dos2unix \
    tini \
    postgresql-client \
    gettext \
    procps \
    python3 \
    python3-pip \
    python3-dev \
    nano \
    vim \
    git \
    gosu \
    && apt-get autoclean \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

USER $UID:$GID

# In slim docker images, mime.types is removed and we need it for mimetypes guessing
COPY --chown=$UID:$GID ./backend/docker/mime.types /etc/

# Install non-dev base dependencies into a virtual env.
COPY --chown=$UID:$GID ./backend/requirements/base.txt /baserow/requirements/
RUN python3 -m pip install --no-cache-dir --no-warn-script-location --disable-pip-version-check --upgrade pip==22.0.3
RUN python3 -m pip install --no-cache-dir --no-warn-script-location --upgrade virtualenv==20.13.1 && python3 -m virtualenv /baserow/venv

ENV PIP_CACHE_DIR=/tmp/baserow_pip_cache
# hadolint ignore=SC1091,DL3042
RUN --mount=type=cache,mode=777,target=$PIP_CACHE_DIR,uid=$UID,gid=$GID . /baserow/venv/bin/activate && pip3 install  -r /baserow/requirements/base.txt

# Build a dev_deps stage which also has the dev dependencies for use by the dev layer.
FROM base as dev_deps

COPY ./backend/requirements/dev.txt /baserow/requirements/
# hadolint ignore=SC1091,DL3042
RUN --mount=type=cache,mode=777,target=$PIP_CACHE_DIR,uid=$UID,gid=$GID . /baserow/venv/bin/activate && pip3 install -r /baserow/requirements/dev.txt

# The core stage contains all of Baserows source code and sets up the entrypoint
FROM base as core

# Copy over backend code.
COPY --chown=$UID:$GID ./docs /baserow/docs
# TODO - This copy also re-copies the requirements above, meaning this will be re-run
#        and not cached even though we already have separate layers above.
COPY --chown=$UID:$GID ./backend /baserow/backend
COPY --chown=$UID:$GID ./premium/backend /baserow/premium/backend

WORKDIR /baserow/backend

# Ensure that Python outputs everything that's printed inside
# the application rather than buffering it.
ENV PYTHONUNBUFFERED 1
ENV PYTHONPATH $PYTHONPATH:/baserow/backend/src:/baserow/premium/backend/src

COPY --chown=$UID:$GID ./deploy/plugins/*.sh /baserow/plugins/
RUN dos2unix /baserow/backend/docker/docker-entrypoint.sh && \
    chmod a+x /baserow/backend/docker/docker-entrypoint.sh

HEALTHCHECK --interval=60s CMD ["/bin/bash", "/baserow/backend/docker/docker-entrypoint.sh", "backend-healthcheck"]
ENTRYPOINT ["/usr/bin/tini", "--", "/bin/bash", "/baserow/backend/docker/docker-entrypoint.sh"]

FROM core as dev


USER root
RUN apt-get update &&  \
    apt-get install -y --no-install-recommends \
    graphviz \
    && apt-get autoclean \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*
USER $UID:$GID

# Override virtualenv with one containing dev dependencies.
COPY --chown=$UID:$GID --from=dev_deps /baserow/venv /baserow/venv

# Override env variables and initial cmd to start up in dev mode.
ENV DJANGO_SETTINGS_MODULE='baserow.config.settings.dev'
CMD ["django-dev"]

FROM core as local

ENV DJANGO_SETTINGS_MODULE='baserow.config.settings.base'
CMD ["gunicorn"]

