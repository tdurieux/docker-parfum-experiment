# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

FROM mcr.microsoft.com/azureml/intelmpi2018.3-ubuntu16.04

# Install azureml-sdk to make the code runnable on azureml platform.
RUN pip install azureml-sdk

# Set env variables
ENV AZUREML_CONDA_ENVIRONMENT_PATH /opt/miniconda