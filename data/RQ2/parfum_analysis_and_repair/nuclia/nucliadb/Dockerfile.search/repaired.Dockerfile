FROM python:3.9

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

RUN pip install --no-cache-dir Cython==0.29.24 pybind11 gunicorn uvicorn uvloop

# Copy requirements from all packages to install them before
# transfering the source code.
COPY nucliadb_utils/requirements.txt /usr/src/app/requirements-utils.txt
COPY nucliadb_utils/requirements-cache.txt /usr/src/app/requirements-cache.txt
COPY nucliadb_utils/requirements-storages.txt /usr/src/app/requirements-storages.txt
COPY nucliadb_utils/requirements-fastapi.txt /usr/src/app/requirements-fastapi.txt
COPY nucliadb_protos/python/requirements.txt /usr/src/app/requirements-protos.txt
COPY nucliadb_models/requirements.txt /usr/src/app/requirements-models.txt
COPY nucliadb_ingest/requirements.txt /usr/src/app/requirements-ingest.txt
COPY nucliadb_search/requirements.txt /usr/src/app/requirements-search.txt
COPY nucliadb_telemetry/requirements.txt /usr/src/app/requirements-telemetry.txt

RUN set -eux; \
    pip install --no-cache-dir \
    -r /usr/src/app/requirements-utils.txt \
    -r /usr/src/app/requirements-storages.txt \
    -r /usr/src/app/requirements-fastapi.txt \
    -r /usr/src/app/requirements-cache.txt \
    -r /usr/src/app/requirements-telemetry.txt \
    -r /usr/src/app/requirements-protos.txt \
    -r /usr/src/app/requirements-models.txt \
    -r /usr/src/app/requirements-ingest.txt \
    -r /usr/src/app/requirements-search.txt

# Copy source code
COPY nucliadb_utils /usr/src/app/nucliadb_utils
COPY nucliadb_telemetry /usr/src/app/nucliadb_telemetry
COPY nucliadb_protos /usr/src/app/nucliadb_protos
COPY nucliadb_models /usr/src/app/nucliadb_models
COPY nucliadb_ingest /usr/src/app/nucliadb_ingest
COPY nucliadb_search /usr/src/app/nucliadb_search

WORKDIR /usr/src/app

# Install all dependendencies on packages on the nucliadb repo
# and finally the main component.
RUN pip install --no-cache-dir -r nucliadb_search/requirements-sources.txt
RUN pip install --no-cache-dir --no-deps -e /usr/src/app/nucliadb_search

# HTTP
EXPOSE 8080/tcp

