FROM python:3.7.11-buster

WORKDIR /usr/src
RUN apt-get update && apt-get install --no-install-recommends -y ffmpeg cmake && rm -rf /var/lib/apt/lists/*
COPY ./versioneer.py ./
COPY ./setup* ./
COPY ./Pipfile* ./
COPY ./docs/requirements.txt ./docs/requirements.txt
COPY ./Makefile ./
COPY ./pyproject.toml ./
COPY ./perception/benchmarking/extensions.pyx ./perception/benchmarking/extensions.pyx
RUN pip install --no-cache-dir pipenv && make init-project && rm -rf /root/.cache/pip
