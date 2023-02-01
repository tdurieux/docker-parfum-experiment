from continuumio/miniconda

RUN apt-get update && apt-get install --no-install-recommends -y vim gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN conda install cython
VOLUME /src
