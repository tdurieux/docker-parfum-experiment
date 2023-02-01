# https://ngc.nvidia.com/registry/nvidia-tensorflow
# FROM nvcr.io/nvidia/tensorflow:18.07-py3

# This seems to work on a wider range of servers
FROM tensorflow/tensorflow:latest-gpu-py3

# Avoid the interactive prompt when installing `tzdata`
# https://techoverflow.net/2019/05/18/how-to-fix-configuring-tzdata-interactive-input-when-building-docker-images/
ENV DEBIAN_FRONTEND=noninteractive

# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    vim \
    screen \
    expect \
    parallel \
 && rm -rf /var/lib/apt/lists/*

# https://github.com/openai/gym/blob/master/Dockerfile
WORKDIR /research/TF-RLLibs
RUN mkdir -p TFLibrary && touch TFLibrary/__init__.py
COPY ./REQUIREMENTS.txt .
COPY ./README.md .
COPY ./setup.py .
RUN pip install -e . && \
    pip install -r REQUIREMENTS.txt

# Finally, upload our actual code
COPY . /research/TF-RLLibs



CMD /bin/bash
