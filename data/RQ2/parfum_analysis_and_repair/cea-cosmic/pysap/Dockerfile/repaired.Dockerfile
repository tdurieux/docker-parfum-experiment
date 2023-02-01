FROM continuumio/miniconda3

LABEL Description="PySAP Docker Image"
WORKDIR /home
ENV SHELL /bin/bash

ARG DEBIAN_FRONTEND=noninteractive
ARG CC=gcc-10
ARG CXX=g++-10

RUN apt-get update && \
    apt-get install --no-install-recommends -y gcc-10 g++-10 && \
    apt-get install --no-install-recommends -y libgl1 && \
    apt-get install --no-install-recommends -y libnfft3-dev && \
    apt-get install --no-install-recommends -y cmake && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/CEA-COSMIC/pysap.git

RUN cd pysap && \
    conda env create -f environment.yml

ENV PATH /opt/conda/envs/pysap/bin:$PATH

RUN echo "path: $PATH" && \
    cd pysap && \
    python -m pip install .

CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
