# Filesystem app

ARG BASE_VERSION="0.16.1"

FROM arxiv/base:${BASE_VERSION}

WORKDIR /opt/arxiv/

# COPY Pipfile Pipfile.lock /opt/arxiv/