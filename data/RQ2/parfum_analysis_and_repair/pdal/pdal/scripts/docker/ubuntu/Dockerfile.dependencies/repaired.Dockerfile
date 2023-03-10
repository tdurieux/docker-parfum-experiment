FROM condaforge/miniforge3
MAINTAINER Howard Butler <howard@hobu.co>

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

SHELL ["conda", "run", "-n", "base", "/bin/bash", "-c"]

RUN \
    conda update -n base -c defaults conda && \
    conda install -c conda-forge -n base conda-pack git compilers cmake make ninja && \
    conda create -n pdal -y && \
    conda install --yes --name pdal -c conda-forge pdal --only-deps