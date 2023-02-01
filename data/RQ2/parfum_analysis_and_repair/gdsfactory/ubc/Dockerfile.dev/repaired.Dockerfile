FROM jupyter/base-notebook:python-3.8.8

# expose klive and jupyter notebook ports
EXPOSE 8082
EXPOSE 8083
EXPOSE 8888

USER root
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    # Common useful utilities
    git \
    htop \
    neovim && rm -rf /var/lib/apt/lists/*;

USER jovyan
COPY --chown=jovyan . /home/jovyan/ubc
COPY --chown=jovyan docs/notebooks /home/jovyan/notebooks
RUN conda init bash

RUN mamba install gdspy -y
RUN mamba install pymeep=*=mpi_mpich_* -y

RUN pip install --no-cache-dir ubcpdk[full]
WORKDIR /home/jovyan
