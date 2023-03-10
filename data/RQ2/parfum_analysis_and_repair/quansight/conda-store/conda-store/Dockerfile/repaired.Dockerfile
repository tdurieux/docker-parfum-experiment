FROM --platform=linux/amd64 condaforge/mambaforge

USER root

RUN apt-get update \
    && apt-get install --no-install-recommends -y curl \
    && rm -rf /var/lib/apt/lists/*

COPY environment.yaml /opt/conda-store/environment.yaml

RUN mamba env create -f /opt/conda-store/environment.yaml

ENV PATH=/opt/conda/condabin:/opt/conda/envs/conda-store/bin:/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH}

COPY ./ /opt/conda-store/

RUN cd /opt/conda-store && \
    pip install --no-cache-dir -e .

RUN mkdir -p /opt/jupyterhub && \
    chown -R 1000:1000 /opt/jupyterhub

WORKDIR /opt/jupyterhub
