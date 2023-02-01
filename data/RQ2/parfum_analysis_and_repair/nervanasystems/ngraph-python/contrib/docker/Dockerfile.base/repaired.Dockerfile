FROM nvidia/cuda:8.0-devel-ubuntu16.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y python-pip python-dev git software-properties-common && \
    apt-get clean autoclean && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip

# this sets up a python3 virtualenv and activates it
ARG python_version=2
RUN if [ $python_version -eq 3 ]; then \
    apt-get install --no-install-recommends -y python3 python3-pip && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    pip3 install --no-cache-dir virtualenv && \
    virtualenv -p python3 /tmp/env3; rm -rf /var/lib/apt/lists/*; fi
ENV PATH="/tmp/env3/bin:$PATH"

WORKDIR /root
