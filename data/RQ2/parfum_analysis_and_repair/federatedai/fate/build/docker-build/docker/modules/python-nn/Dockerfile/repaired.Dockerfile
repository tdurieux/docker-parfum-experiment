# runtime environment
ARG PREFIX=prefix
ARG BASE_TAG=tag
FROM ${PREFIX}/python:${BASE_TAG}

COPY requirements.txt /data/projects/python/
RUN pip install --no-cache-dir -r /data/projects/python/requirements.txt
