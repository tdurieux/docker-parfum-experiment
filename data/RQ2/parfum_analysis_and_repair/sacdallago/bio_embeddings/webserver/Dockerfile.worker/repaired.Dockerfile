# This file is nearly equivalent to the rostlab/bio_embeddings dockerfile,
# except that we install the webserver dependencies and launch the worker

# This location of python in venv-build needs to match the location in the runtime image,
# so we're manually installing the required python environment
FROM ubuntu:20.04 as venv-build

ENV PYTHONUNBUFFERED=1

# build-essential is for jsonnet
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl build-essential python3 python3-pip python3-distutils python3-venv python3-dev python3-virtualenv git && \
    curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python3 - --version 1.1.7 && rm -rf /var/lib/apt/lists/*;

COPY pyproject.toml /app/pyproject.toml
COPY poetry.lock /app/poetry.lock


WORKDIR /app

# Installs a recent version of pip, otherwise the installation of manylinux2010 packages will fail
# The __init__.py and README.md makes sure poetry installs the metadata for bio_embeddings
RUN mkdir bio_embeddings && \
    touch bio_embeddings/__init__.py && \
    touch README.md && \
    python3 -m venv .venv && \
    .venv/bin/pip install -U pip && \
    $HOME/.local/bin/poetry config virtualenvs.in-project true && \
    $HOME/.local/bin/poetry install --no-dev -E transformers -E webserver && \
    .venv/bin/pip install 'colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold'

FROM nvidia/cuda:11.4.3-runtime-ubuntu20.04

ENV PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install --no-install-recommends -y python3 python3-distutils \
    && rm -rf /var/lib/apt/lists/*

# Workaround for when switching the docker user
# https://github.com/numba/numba/issues/4032#issuecomment-547088606
RUN mkdir /tmp/numba_cache && chmod 777 /tmp/numba_cache
ENV NUMBA_CACHE_DIR=/tmp/numba_cache

USER www-data

COPY --chown=www-data:www-data --from=venv-build /app/.venv /app/.venv
COPY --chown=www-data:www-data . /app/

WORKDIR /app

ENV MODEL_DIRECTORY /mnt/models

ENTRYPOINT ["/app/.venv/bin/celery", "worker", "-A", "webserver.celery_worker.task_keeper", "--loglevel=info", "--pool=solo", "--queues=pipeline,prott5,prott5_annotations,prott5_residue_landscape_annotations,colabfold"]


