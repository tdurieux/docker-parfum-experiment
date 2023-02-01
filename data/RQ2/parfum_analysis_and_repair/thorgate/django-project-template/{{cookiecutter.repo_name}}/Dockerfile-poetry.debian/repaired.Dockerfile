# Dockerfile for Poetry wrapper
# The first build steps of this file are identical to those in the Django Dockerfile to make the build a bit faster.

FROM {{ python_image(cookiecutter.python_version, DEBIAN) }}

ENV PYTHONPYCACHEPREFIX /.pycache

# Let all *.pyc files stay within the container, for Python >= 3.8
RUN mkdir -p $PYTHONPYCACHEPREFIX

# Use non-interactive frontend for debconf
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install system requirements
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential gettext libpq-dev zlib1g-dev libjpeg62-turbo-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy Python requirements dir and Install requirements
RUN pip install --no-cache-dir -U pip 'setuptools<58' wheel poetry

ARG DPT_VENV_CACHING

# if --build-arg DPT_VENV_CACHING=1, set POETRY_VIRTUALENVS_CREATE to '1' or set to null otherwise.
ENV POETRY_VIRTUALENVS_CREATE=${DPT_VENV_CACHING:+1}
# if POETRY_VIRTUALENVS_CREATE is null, set it to '0' (or leave as is otherwise).
ENV POETRY_VIRTUALENVS_CREATE=${POETRY_VIRTUALENVS_CREATE:-0}

# -- begin image-specific commands

# This script provides poetry.lock checking
COPY scripts/poetry-check-lock.sh /

# This provides a helper to generate the ENV_FOLDER value for Dockerfile-django (for venv caching)
COPY ./scripts/generate_path.py /generate-path.py

VOLUME /src
WORKDIR /src
