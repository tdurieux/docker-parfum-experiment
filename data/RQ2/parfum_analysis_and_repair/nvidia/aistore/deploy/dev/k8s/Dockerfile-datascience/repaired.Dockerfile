#
# Dockerfile to build Datascience stack
# using the official jupyter notebook image as base
#

FROM golang:1.18 AS builder

ENV GOPATH="/go"
ENV PATH="${GOPATH}/bin:${PATH}"

RUN git clone https://github.com/NVIDIA/aistore.git && cd aistore && \
    make cli && \
    mv cmd/cli/autocomplete /tmp/autocomplete && \
    cd .. && rm -rf aistore

FROM jupyter/scipy-notebook:399cbb986c6b

RUN pip install --quiet --no-cache-dir torch==1.7.1+cpu \
    torchvision==0.8.2+cpu -f https://download.pytorch.org/whl/torch_stable.html && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

USER root

RUN apt-get update -y && apt-get --no-install-recommends -y install \
    curl \
    git \
    wget && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin /usr/local/bin/

# Install autocomplete.