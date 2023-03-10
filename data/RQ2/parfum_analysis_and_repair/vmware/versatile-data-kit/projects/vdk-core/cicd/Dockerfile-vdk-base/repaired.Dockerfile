# Specifies a base image containing installed and ready to use VDK
# https://docs.docker.com/develop/develop-images/dockerfile_best-practices

FROM python:3.7-slim

WORKDIR /vdk

ENV VDK_VERSION $vdk_version

# Install VDK
ARG vdk_version
ARG vdk_package
ARG pip_extra_index_url
RUN pip install --no-cache-dir --extra-index-url $pip_extra_index_url $vdk_package==$vdk_version
