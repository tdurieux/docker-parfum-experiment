# This is meant to turn a pip requirements.txt file into a container. To be used like:
# docker build -t image_name:tag --build-arg ENV_FILE=requirements.txt --build-arg PYTHON_VERSION=3.10 -f src/meadowrun/docker_files/PipDockerfile .
# This assumes that ./requirements.txt exists and defines the environment

ARG PYTHON_VERSION

FROM python:$PYTHON_VERSION-slim-bullseye

ARG ENV_FILE

WORKDIR /tmp/
COPY $ENV_FILE ./
RUN pip install --no-cache-dir -r $ENV_FILE
