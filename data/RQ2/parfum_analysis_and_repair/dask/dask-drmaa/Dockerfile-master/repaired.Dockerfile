FROM ubuntu:14.04

ENV LANG C.UTF-8

RUN apt-get update && apt-get install --no-install-recommends curl bzip2 git gcc -y --fix-missing && rm -rf /var/lib/apt/lists/*;

RUN curl -f -o miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash miniconda.sh -f -b -p /opt/anaconda && \
    /opt/anaconda/bin/conda clean -tipy && \
    rm -f miniconda.sh
ENV PATH /opt/anaconda/bin:$PATH
RUN conda install -n root conda=4.4.11 && conda clean -tipy
RUN conda install -c conda-forge dask distributed blas pytest mock ipython pip psutil python-drmaa && conda clean -tipy

COPY ./*.sh /
COPY ./*.txt /
RUN bash ./setup-master.sh

# expose ports
EXPOSE 8000
EXPOSE 6444
EXPOSE 6445
EXPOSE 6446

ENV DRMAA_LIBRARY_PATH /usr/lib/gridengine-drmaa/lib/libdrmaa.so
ENV SGE_ROOT /var/lib/gridengine/
ENV SGE_CELL default
