# Build with docker build . -f doc/Dockerfile.docs --output doc-html
# Built documentation will be placed in the doc-html folder.

# Ubuntu Focal for Python >= 3.7
FROM ubuntu:focal-20210325 as build
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    doxygen \
    git \
    npm \
    make \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Setup virtualenv
ENV VIRTUAL_ENV=/tmp/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN python3 -m pip install -U pip setuptools wheel

# First just requirements so we don't re-run pip install every time
COPY doc/requirements.txt /code/doc/requirements.txt
COPY doc/Makefile /code/doc/Makefile
WORKDIR /code/doc
RUN make python-reqs

# Then rest of code for docs build
COPY . /code
WORKDIR /code/doc
RUN make html

# Output target only containing built files