FROM python:3.8-buster

ENV PROJECT_DIR /mlflow/projects
ENV CODE_DIR /mlflow/projects/code
WORKDIR /${PROJECT_DIR}
ADD requirements.txt /${PROJECT_DIR}/

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install apt-utils gcc && \
    pip install  --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;

WORKDIR /${CODE_DIR}