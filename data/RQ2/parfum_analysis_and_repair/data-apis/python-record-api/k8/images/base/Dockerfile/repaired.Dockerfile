FROM python:3.8.4

ARG PYTHON_PACKAGE

WORKDIR /usr/src/base

COPY . .

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir ${PYTHON_PACKAGE}

