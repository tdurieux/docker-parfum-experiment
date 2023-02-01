FROM python:3.7-slim-stretch

ARG BUILD_ENV
ENV PYTHONPATH="/opt/app/src:${PYTHONPATH}"

WORKDIR /opt/app

COPY ["build", "Pipfile.lock", "Pipfile", "./"]
RUN ./pipenv-install.sh

COPY ["src", "src"]
RUN ./python-linter.sh src

COPY ["tests", "tests"]
RUN ./unittest.sh

RUN ./cleanup.sh
