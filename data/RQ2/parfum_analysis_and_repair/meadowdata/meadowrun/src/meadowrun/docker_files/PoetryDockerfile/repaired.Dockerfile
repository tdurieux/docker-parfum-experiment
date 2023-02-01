# This is meant to turn a pip requirements.txt file into a container. To be used like:
# docker build -t image_name:tag --build-arg PYTHON_VERSION=3.10 -f src/meadowrun/docker_files/PoetryDockerfile .
# This assumes that ./pyproject.toml and ./poetry.lock exist

ARG PYTHON_VERSION

FROM python:$PYTHON_VERSION-slim-bullseye

ARG ENV_FILE

WORKDIR /tmp/
COPY pyproject.toml ./
COPY poetry.lock ./

# curl/wget isn't available, but we can just use python
# TODO ideally we (or someone) would pre-build a bunch of versions python with poetry already installed