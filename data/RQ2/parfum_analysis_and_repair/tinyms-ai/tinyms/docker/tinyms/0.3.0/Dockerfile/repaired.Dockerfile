ARG BASE_CONTAINER=swr.cn-south-1.myhuaweicloud.com/mindspore/mindspore-cpu:1.5.0
FROM $BASE_CONTAINER

LABEL MAINTAINER="TinyMS Authors"

# Install base tools
RUN apt-get update && apt-get install --no-install-recommends libglib2.0-dev libsm6 libxrender1 -y && rm -rf /var/lib/apt/lists/*; # Install opencv dependencies software


# Install TinyMS cpu whl package
RUN pip install --no-cache-dir tinyms==0.3.0
