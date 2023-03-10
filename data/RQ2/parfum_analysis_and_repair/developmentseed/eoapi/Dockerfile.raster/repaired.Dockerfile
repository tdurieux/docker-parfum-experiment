ARG PYTHON_VERSION=3.9

FROM ghcr.io/vincentsarago/uvicorn-gunicorn:${PYTHON_VERSION}

ENV CURL_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt

RUN pip install --no-cache-dir psycopg[binary,pool]

COPY src/eoapi/raster /tmp/raster
RUN pip install --no-cache-dir /tmp/raster
RUN rm -rf /tmp/raster

ENV MODULE_NAME eoapi.raster.app
ENV VARIABLE_NAME app
