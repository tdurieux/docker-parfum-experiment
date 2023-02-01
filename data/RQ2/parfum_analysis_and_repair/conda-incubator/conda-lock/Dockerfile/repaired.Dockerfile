FROM continuumio/miniconda:latest

RUN pip install --no-cache-dir conda-lock

ENTRYPOINT conda-lock