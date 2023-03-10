# Dockerfile for building docker images to run notebooks
# in.
ARG BASE_IMAGE=gcr.io/kubeflow-images-public/tensorflow-1.15.2-notebook-cpu:1.0.0

FROM $BASE_IMAGE

USER root

# See https://github.com/kubeflow/gcp-blueprints/issues/174#issuecomment-732787054
RUN pip3 uninstall -y enum34
RUN pip3 install --no-cache-dir -Iv papermill==2.0.0
RUN pip3 install --no-cache-dir -U nbconvert nbformat retrying

USER jovyan

# Copy any source code into /src
COPY . /src

