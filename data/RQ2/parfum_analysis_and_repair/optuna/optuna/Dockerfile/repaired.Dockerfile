ARG PYTHON_VERSION=3.8

FROM python:${PYTHON_VERSION}

ENV PIP_OPTIONS "--no-cache-dir --progress-bar off"

RUN apt-get update \
    && apt-get -y --no-install-recommends install openmpi-bin libopenmpi-dev libopenblas-dev \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir -U pip \
    && pip install --no-cache-dir ${PIP_OPTIONS} -U setuptools

WORKDIR /workspaces
COPY . .

ARG BUILD_TYPE='dev'

RUN if [ "${BUILD_TYPE}" = "dev" ]; then \
        if [ "${PYTHON_VERSION}" \< "3.6" ]; then \
            pip install --no-cache-dir ${PIP_OPTIONS} -e '.[document, integration]' -f https://download.pytorch.org/whl/torch_stable.html; \
        else \
            pip install --no-cache-dir ${PIP_OPTIONS} -e '.[checking, document, integration]' -f https://download.pytorch.org/whl/torch_stable.html; \
        fi \
    else \
        pip install --no-cache-dir ${PIP_OPTIONS} -e .; \
    fi \
    && pip install --no-cache-dir ${PIP_OPTIONS} jupyter notebook

# Install RDB bindings.
RUN pip install --no-cache-dir ${PIP_OPTIONS} PyMySQL cryptography psycopg2-binary

ENV PIP_OPTIONS ""
