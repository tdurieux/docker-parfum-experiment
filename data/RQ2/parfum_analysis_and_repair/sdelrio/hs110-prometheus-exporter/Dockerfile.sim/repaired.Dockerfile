#######################################################
# BASE IMAGE
#######################################################
ARG BASE_IMAGE=python
ARG BASE_IMAGE_TAG=3.8-alpine3.13

FROM $BASE_IMAGE:$BASE_IMAGE_TAG as base

# Set python env
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

ARG USER_ID=1000
ARG USER_NAME=app
ARG GROUP_ID=1000
ARG GROUP_NAME=app

# Create user
RUN addgroup -S -g $GROUP_ID $GROUP_NAME && \
    adduser -S -G $GROUP_NAME -u $USER_ID $USER_NAME

#######################################################
# BUILDER IMAGE
#######################################################
FROM base as build

COPY requirements.alpine .
RUN cat requirements.alpine | xargs apk add --no-cache


COPY requirements.txt /tmp/requirements.txt
# Install runtime dependencies iinto /usr/local/lib/python3.x/site-packages
RUN pip install \
        --no-cache-dir \
        -r /tmp/requirements.txt

#######################################################
# RUN IMAGE
#######################################################
FROM base as run

ARG USER_ID=1000
ARG USER_NAME=app
ARG GROUP_ID=1000
ARG GROUP_NAME=app

# Get pip installed packages from build image