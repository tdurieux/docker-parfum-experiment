FROM mambaorg/micromamba:0.23.0

USER root

RUN apt-get update && \
    apt-get install --no-install-recommends -y git && \
    rm -rf /var/lib/{apt,dpkg,cache,log} && rm -rf /var/lib/apt/lists/*;

USER $MAMBA_USER

COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml /tmp/environment.yml

RUN micromamba install -y -n base -f /tmp/environment.yml && \
    micromamba clean --all --yes

COPY --chown=$MAMBA_USER:$MAMBA_USER . /opt/chemprop

WORKDIR /opt/chemprop

RUN /opt/conda/bin/python -m pip install -e .

