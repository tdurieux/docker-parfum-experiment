# Build and run:
#
#   docker build -t faunus - < Dockerfile
#   docker run -it -p 8888:8888 faunus
#   (copy-paste generated url into browser)
#
# What is installed?
#
# - Based on jupyter/scipy - https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html
# - gcc11, cmake, openmpi, parmed, nglview, mdtraj, faunus
# - faunus main branch compiled w. openmp, mpi, python
# - clone of mlund/chemistry-notebooks
#
ARG OWNER=jupyter
ARG BASE_CONTAINER=jupyter/scipy-notebook:lab-3.3.2
FROM $BASE_CONTAINER

LABEL maintainer="the faun"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    cmake \
    gcc-11 \
    g++-11 \
    libopenmpi-dev openmpi-bin openmpi-common \
    zlib1g-dev && \
    apt autoremove --yes && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER ${NB_UID}
RUN mamba install --quiet --yes \
    'jsonschema' \
    'jinja2' \
    'pypandoc' \
    'yaml' \
    'nglview' \
    'ruamel' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN pip install --no-cache-dir --no-input mdtraj
RUN git clone https://github.com/mlund/chemistry-notebooks.git

USER root
RUN git clone https://github.com/mlund/faunus.git && \
    export CXX=g++-11 && \
    export CC=gcc-11 && \
    cd faunus && \
    cmake -DENABLE_PYTHON=on -DENABLE_OPENMP=on -DENABLE_MPI=on -DCMAKE_BUILD_TYPE=RelWithDebInfo -DPYBIND11_FINDPYTHON=on . && \
    make faunus && \
    make pyfaunus && \
    make install && \
    make clean && \
    cd .. && \
    rm -fR faunus
