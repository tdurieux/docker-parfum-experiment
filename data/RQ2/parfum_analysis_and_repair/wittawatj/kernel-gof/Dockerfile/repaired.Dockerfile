# Set the base image

# Dockerfile at https://github.com/ContinuumIO/docker-images/blob/master/miniconda/Dockerfile
FROM continuumio/miniconda

RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir jupyter

# install kgof from https://github.com/wittawatj/kernel-gof
RUN pip install --no-cache-dir git+https://github.com/wittawatj/kernel-gof.git

MAINTAINER Wittawat Jitkrittum <wittawatj@gmail.com>

