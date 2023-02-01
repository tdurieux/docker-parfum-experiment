FROM python:3.8-slim-buster

WORKDIR /root
ENV VENV /opt/venv
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONPATH /root

RUN apt-get update && apt-get install --no-install-recommends -y build-essential git-all && rm -rf /var/lib/apt/lists/*;

# Install the AWS cli separately to prevent issues with boto being written over
RUN pip3 install --no-cache-dir awscli
# Similarly, if you're using GCP be sure to update this command to install gsutil
# RUN curl -sSL https://sdk.cloud.google.com | bash
# ENV PATH="$PATH:/root/google-cloud-sdk/bin"

ENV VENV /opt/venv
# Virtual environment
RUN python3 -m venv ${VENV}
ENV PATH="${VENV}/bin:$PATH"

# Install Python dependencies and source code
COPY ./requirements.txt /root
RUN pip install --no-cache-dir -r /root/requirements.txt
COPY . /root
