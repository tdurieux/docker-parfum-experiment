ARG BASE_CONTAINER=jupyter/scipy-notebook:74b0a01aebb1
FROM $BASE_CONTAINER

USER root

RUN apt-get update && apt-get install --no-install-recommends -y -q \
        build-essential \
        && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --no-cache infomap \
        && fix-permissions $CONDA_DIR \
        && fix-permissions /home/$NB_USER

USER $NB_UID

VOLUME /home/jovyan/work