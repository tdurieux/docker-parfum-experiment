FROM gitpod/workspace-postgres:latest

USER root

RUN pip install --no-cache-dir httpie

USER gitpod
