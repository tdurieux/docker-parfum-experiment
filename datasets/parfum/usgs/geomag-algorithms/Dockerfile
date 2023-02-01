ARG FROM_IMAGE=usgs/python:3.9-obspy

# build wheel
FROM ${FROM_IMAGE} as build

USER root
WORKDIR /app

# install dependencies in separate layer
# this is a temporary container and they change less often than other files
COPY poetry.lock pyproject.toml /app/
RUN poetry install --no-root

COPY . /app/
RUN poetry build


# install and configure entrypoint
FROM ${FROM_IMAGE}

ARG GIT_BRANCH_NAME=none
ARG GIT_COMMIT_SHA=none
ARG WEBSERVICE="false"

# set environment variables
ENV GIT_BRANCH_NAME=${GIT_BRANCH_NAME} \
    GIT_COMMIT_SHA=${GIT_COMMIT_SHA} \
    WEBSERVICE=${WEBSERVICE}

COPY --from=build /app/dist/*.whl /app/docker-entrypoint.sh /app/

# install as root
USER root
RUN apt update \
    && apt upgrade -y \
    && pip install /app/*.whl \
    && pip cache purge
USER usgs-user

# entrypoint needs double quotes
ENTRYPOINT [ "/app/docker-entrypoint.sh" ]
EXPOSE 8000
