FROM ubuntu:16.04

ENV py_version=3

# Validate that arguments are specified
RUN test $py_version || exit 1

# Install python and nginx
RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        jq \
        libsm6 \
        libxext6 \
        libxrender-dev \
        nginx && \
    if [ $py_version -eq 3 ]; \
       then apt-get install -y --no-install-recommends python3.6-dev \
           && ln -s -f /usr/bin/python3.6 /usr/bin/python; \
       else apt-get install -y --no-install-recommends python-dev; fi && \
    rm -rf /var/lib/apt/lists/*

# Install pip
RUN cd /tmp && \
    curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py 'pip<=18.1' && rm get-pip.py

# Python won’t try to write .pyc or .pyo files on the import of source modules
# Force stdin, stdout and stderr to be totally unbuffered. Good for logging
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PYTHONIOENCODING=UTF-8 LANG=C.UTF-8 LC_ALL=C.UTF-8

# Install dependencies from pip
RUN if [ $py_version -eq 3 ]; \
        then pip install --no-cache-dir https://download.pytorch.org/whl/cpu/torch-1.1.0-cp36-cp36m-linux_x86_64.whl \
        https://download.pytorch.org/whl/cpu/torchvision-0.3.0-cp36-cp36m-linux_x86_64.whl fastai==1.0.39; \
        else pip install --no-cache-dir https://download.pytorch.org/whl/cpu/torch-1.1.0-cp27-cp27mu-linux_x86_64.whl \
        https://download.pytorch.org/whl/cpu/torchvision-0.3.0-cp27-cp27mu-linux_x86_64.whl; fi && \
    pip install --no-cache-dir 'opencv-python>=4.0,<4.1' Pillow retrying six
