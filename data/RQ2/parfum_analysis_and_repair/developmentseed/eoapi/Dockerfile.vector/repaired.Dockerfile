ARG PYTHON_VERSION=3.9

FROM ghcr.io/vincentsarago/uvicorn-gunicorn:${PYTHON_VERSION}

RUN pip install --no-cache-dir psycopg2

COPY src/eoapi/vector /tmp/vector
RUN pip install --no-cache-dir /tmp/vector
RUN rm -rf /tmp/vector

ENV MODULE_NAME eoapi.vector.app
ENV VARIABLE_NAME app
