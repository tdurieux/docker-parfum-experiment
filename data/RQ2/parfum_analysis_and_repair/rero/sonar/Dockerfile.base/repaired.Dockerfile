# -*- coding: utf-8 -*-
#
# Swiss Open Access Repository
# Copyright (C) 2021 RERO
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Base image Dockerfile for sonar application.
#
# This image installs all Python dependencies for your application. It's based
# on CentOS 7 with Python 3 (https://github.com/inveniosoftware/docker-invenio)
# and includes Pip, Pipenv, Node.js, NPM and some few standard libraries
# Invenio usually needs.

FROM python:3.9-slim-buster

# require debian packages
RUN apt-get upgrade -y && apt-get update -y
RUN apt-get install --no-install-recommends -y git vim-tiny curl gcc g++ pkg-config gnupg libc6-dev libxml2-dev libxmlsec1-dev libxmlsec1-openssl xpdf xpdf-utils ghostscript imagemagick && rm -rf /var/lib/apt/lists/*
RUN sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="read" pattern="PDF" \/>/g' /etc/ImageMagick-6/policy.xml
RUN pip install --no-cache-dir --upgrade wheel pip poetry

# # Install Node
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*

# Env variables
ENV WORKING_DIR=/invenio
ENV INVENIO_INSTANCE_PATH=${WORKING_DIR}/var/instance

# Create directories
RUN mkdir -p ${INVENIO_INSTANCE_PATH}
RUN mkdir -p ${WORKING_DIR}/src
RUN mkdir -p ${WORKING_DIR}/instance

# copy everything inside /src
COPY ./ ${WORKING_DIR}/src
WORKDIR ${WORKING_DIR}/src

# copy uwsgi config files
COPY ./docker/uwsgi/ ${INVENIO_INSTANCE_PATH}

# Set folder permissions
ENV INVENIO_USER_ID=1000
RUN useradd invenio --uid ${INVENIO_USER_ID}  --home ${WORKING_DIR} && \
    chown -R invenio:invenio ${WORKING_DIR} && \
    chmod -R go+w ${WORKING_DIR}

# Install dependencies
RUN poetry run pip install --upgrade pip "setuptools<58"
RUN poetry install --no-dev


