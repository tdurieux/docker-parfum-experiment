FROM camptocamp/geomapfish-tools as base

# Used to convert the locked packages by poetry to pip requirements format
# We don't directly use `poetry install` because it force to use a virtual environment.
FROM base as poetry

# Install Poetry
WORKDIR /tmp
COPY requirements.txt ./
RUN --mount=type=cache,target=/root/.cache \
    python3 -m pip install --disable-pip-version-check --requirement=requirements.txt

# Do the conversion
COPY poetry.lock pyproject.toml ./
RUN poetry export --output=requirements.txt \
    && poetry export --dev --output=requirements-dev.txt

# Base, the biggest thing is to install the Python packages
FROM base

# Fail on error on pipe, see: https://github.com/hadolint/hadolint/wiki/DL4006.
# Treat unset variables as an error when substituting.
# Print commands and their arguments as they are executed.
SHELL ["/bin/bash", "-o", "pipefail", "-cux"]

RUN --mount=type=cache,target=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache,sharing=locked \
    . /etc/os-release \
    && apt-get update \
    && apt-get install -y --assume-yes --no-install-recommends curl gnupg \
    && echo "deb https://deb.nodesource.com/node_16.x ${VERSION_CODENAME} main" > /etc/apt/sources.list.d/nodesource.list \
    && curl -f --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && apt-get update \
    && apt-get install -y --assume-yes --no-install-recommends 'nodejs=16.*' && rm -rf /var/lib/apt/lists/*;

RUN --mount=type=cache,target=/var/cache,sharing=locked \
    --mount=type=cache,target=/root/.cache \
    --mount=type=bind,from=poetry,source=/tmp,target=/poetry \
    python3 -m pip install --disable-pip-version-check --no-deps --requirement=/poetry/requirements.txt

# To be removed when tilecloudchain will use c2cwsgiutils 5.0
RUN mkdir -p /usr/local/lib/python3.8/dist-packages/tilecloud_chain/ \
    && curl -f https://raw.githubusercontent.com/camptocamp/tilecloud-chain/master/tilecloud_chain/USAGE.rst -o \
        /usr/local/lib/python3.8/dist-packages/tilecloud_chain/USAGE.rst \
    && curl -f https://raw.githubusercontent.com/camptocamp/tilecloud-chain/master/tilecloud_chain/schema.json -o \
        /usr/local/lib/python3.8/dist-packages/tilecloud_chain/schema.json

COPY package.json package-lock.json /doc/
RUN --mount=type=cache,target=/var/cache,sharing=locked \
    --mount=type=cache,target=/root/.cache \
    cd /doc && npm install && npm cache clean --force;

COPY . /doc
WORKDIR /doc

ARG MAJOR_VERSION
ARG MAIN_BRANCH

RUN ./import_ngeo_config.py --type Configuration integrator/ngeo_configuration.rst \
    --type APIConfig integrator/ngeo_api_configuration.rst \
    node_modules/ngeo/dist/typedoc.json integrator/ngeo_other_configuration.rst \
    && mkdir --parent _build/html \
    && sphinx-build -b html -d _build/doctrees . _build/html \
    && ./build.sh
