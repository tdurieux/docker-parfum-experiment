# Docker image based on Jupyter Python stack with preinstalled CrossbarFX integration
# https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-tensorflow-notebook

FROM jupyter/tensorflow-notebook

RUN pip install --no-cache-dir -U pip && pip install --no-cache-dir autobahn[asyncio] zlmdb
