FROM jupyter/base-notebook:b4dd11e16ae4

RUN pip install --no-cache-dir there
ADD verify verify
