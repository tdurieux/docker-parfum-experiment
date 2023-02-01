FROM jupyter/base-notebook

USER $NB_UID
RUN pip install --no-cache-dir ecell4
