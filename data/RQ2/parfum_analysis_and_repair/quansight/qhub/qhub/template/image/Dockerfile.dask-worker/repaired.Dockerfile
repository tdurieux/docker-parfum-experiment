FROM ubuntu:20.04
LABEL MAINTAINER="Quansight"

COPY scripts/install-apt-minimal.sh /opt/scripts/install-apt-minimal.sh
RUN /opt/scripts/install-apt-minimal.sh

COPY scripts/fix-permissions /opt/scripts/fix-permissions

ENV CONDA_VERSION py38_4.10.3
ENV CONDA_SHA256 935d72deb16e42739d69644977290395561b7a6db059b316958d97939e9bdf3d
SHELL ["/bin/bash", "-c"]

ENV PATH=/opt/conda/bin:${PATH}:/opt/scripts

# ============== base install ===============
COPY scripts/install-conda.sh /opt/scripts/install-conda.sh

RUN /opt/scripts/install-conda.sh

# ========== dask-worker install ===========
COPY dask-worker/environment.yaml /opt/dask-worker/environment.yaml
COPY scripts/install-conda-environment.sh /opt/scripts/install-conda-environment.sh
RUN /opt/scripts/install-conda-environment.sh /opt/dask-worker/environment.yaml 'false'

# ========== Setup GPU Paths ============
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib64
ENV NVIDIA_PATH=/usr/local/nvidia/bin
ENV PATH="$NVIDIA_PATH:$PATH"

COPY dask-worker /opt/dask-worker
RUN /opt/dask-worker/postBuild