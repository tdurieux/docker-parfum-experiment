FROM jupyter/scipy-notebook:python-3.8.8

## whoami you can use this to see who the user is


USER root

RUN apt-get update && \
    apt-get install --no-install-recommends -y openjdk-11-jre-headless graphviz && \
    apt-get clean; rm -rf /var/lib/apt/lists/*;

# RUN apt-get -y -qq update \
#    && apt-get -y -qq install make gcc

USER jovyan

COPY docker/jupyter-experimental/local/jars/* /usr/local/spark/jars/
COPY docker/jupyter-experimental/extra_jars/* /usr/local/spark/jars/
COPY docker/jupyter-experimental/local/requirements.txt /tmp/requirements.txt
COPY docker/jupyter-experimental/extra_requirements.txt /tmp/extra_requirements.txt

WORKDIR /tmp

RUN python3 -m pip install --upgrade pip &&\
    python3 -m pip install --prefer-binary -r requirements.txt &&\
    python3 -m pip install --prefer-binary -r extra_requirements.txt

WORKDIR /home/shared