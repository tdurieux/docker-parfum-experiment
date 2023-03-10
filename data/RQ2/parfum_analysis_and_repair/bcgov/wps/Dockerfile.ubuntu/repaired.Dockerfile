# Currenly only used by the c-haines cronjob, which needs a new version of gdal than is provided
# by the debian image used to serve up the api.
ARG DOCKER_IMAGE=image-registry.openshift-image-registry.svc:5000/e1e498-tools/ubuntu-base:20.04

# Using local docker image to speed up build. See openshift/unicorn-base for details.
FROM ${DOCKER_IMAGE}

# Copy poetry files.
COPY ./api/pyproject.toml ./api/poetry.lock /tmp/

# Make sure we have an up to date pip
RUN cd /tmp && \
    poetry run python3 -m pip install --upgrade pip

# Poetry fails to install cryptography correctly on ubuntu 20.04. If we make
# sure it's installed globally first, then it works.
RUN python3 -m pip install cryptography

# Install dependancies.
RUN cd /tmp && \
    poetry install --no-root --no-dev

# Copy the app: