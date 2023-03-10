# We use devel because plugins_sagemaker-training needs gcc to build
# TODO get rid of plugins_sagemaker-training
FROM python:3.8-slim-buster
LABEL org.opencontainers.image.source https://github.com/flyteorg/flytesnacks

WORKDIR /root
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONPATH /root
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Install basics
RUN apt-get update && apt-get install --no-install-recommends -y make build-essential libssl-dev curl && rm -rf /var/lib/apt/lists/*;

# Install the AWS cli separately to prevent issues with boto being written over
RUN pip install --no-cache-dir awscli

WORKDIR /opt
RUN curl -f https://sdk.cloud.google.com > install.sh
RUN bash /opt/install.sh --install-dir=/opt
ENV PATH $PATH:/opt/google-cloud-sdk/bin
WORKDIR /root

# Install gcc , g++ and make
RUN apt-get update && apt-get install --no-install-recommends -y gcc g++ && rm -rf /var/lib/apt/lists/*;
RUN echo 'installing make' \
    && apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;

ENV VENV /opt/venv
# Virtual environment
RUN python3 -m venv ${VENV}
ENV PATH="${VENV}/bin:$PATH"

# Install Python dependencies
COPY sagemaker_pytorch/requirements.txt /root/.
RUN pip install --no-cache-dir -r /root/requirements.txt

# Setup Sagemaker entrypoints
ENV SAGEMAKER_PROGRAM /opt/venv/bin/flytekit_sagemaker_runner.py

# Copy the makefile targets to expose on the container. This makes it easier to register.
COPY in_container.mk /root/Makefile
COPY sagemaker_pytorch/sandbox.config /root

# Copy the actual code
COPY sagemaker_pytorch/ /root/sagemaker_pytorch

# This tag is supplied by the build script and will be used to determine the version
# when registering tasks, workflows, and launch plans
ARG tag
ENV FLYTE_INTERNAL_IMAGE $tag
