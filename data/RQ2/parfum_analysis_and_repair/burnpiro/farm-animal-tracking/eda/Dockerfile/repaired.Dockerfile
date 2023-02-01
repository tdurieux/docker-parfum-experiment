FROM jupyter/scipy-notebook

USER root

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt && rm requirements.txt

ENV WORK_DIR ${HOME}/work