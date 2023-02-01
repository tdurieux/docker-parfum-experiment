# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

FROM linkernetworks/base-notebook:master-py2

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER root

# Install all OS dependencies for fully functional notebook server
RUN apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    emacs \
    git \
    inkscape \
    jed \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    pandoc \
    python-dev \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-xetex \
    unzip \
    vim \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV HOME=/

RUN pip install --no-cache-dir pip==9.0.3 \
    && pip install --no-cache-dir -U h5py \
    && pip install --no-cache-dir ipywidgets \
    && jupyter nbextension enable --sys-prefix --py widgetsnbextension \
    && rm -rf ~/.cache/pip

WORKDIR /workspace
