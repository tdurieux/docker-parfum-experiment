FROM continuumio/miniconda3:4.9.2

RUN apt-get update --fix-missing && \
    apt-get install --no-install-recommends -y gcc && \
    apt-get install --no-install-recommends -y g++ && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN conda install libmagic && \
    conda clean -afy

RUN pip install aiohttp --no-cache-dir && \
    pip install git+https://github.com/hi-primus/optimus.git@develop-22.6 --no-cache-dir















