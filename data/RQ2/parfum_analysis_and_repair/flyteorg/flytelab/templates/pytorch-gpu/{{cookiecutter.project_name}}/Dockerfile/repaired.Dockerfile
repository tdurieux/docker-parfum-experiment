FROM pytorch/pytorch:1.9.0-cuda10.2-cudnn7-runtime

WORKDIR /root
ENV VENV /opt/venv
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONPATH /root

# e.g. flyte.config or sandbox.config
ARG config

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    libsm6 \
    libxext6 \
    libxrender-dev \
    ffmpeg \
    build-essential && rm -rf /var/lib/apt/lists/*;

# Install the AWS cli separately to prevent issues with boto being written over
RUN pip3 install --no-cache-dir awscli

ENV VENV /opt/venv

# Virtual environment
RUN python3 -m venv ${VENV}
ENV PATH="${VENV}/bin:$PATH"

# Install Python dependencies
COPY requirements.txt /root
RUN pip install --no-cache-dir -r /root/requirements.txt

COPY {{cookiecutter.project_name}} /root/{{cookiecutter.project_name}}
COPY $config /root/flyte.config

# This image is supplied by the build script and will be used to determine the version
# when registering tasks, workflows, and launch plans
ARG image
ENV FLYTE_INTERNAL_IMAGE $image
