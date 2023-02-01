FROM python:slim
WORKDIR /github/workspace
RUN pip install --no-cache-dir yamllint