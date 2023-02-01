FROM nvidia/cuda:10.2-devel-ubuntu18.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y git python3-pip && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install -U pip && \
    python3 -m pip install -U jax jaxlib==0.1.57+cuda102 -f https://storage.googleapis.com/jax-releases/jax_releases.html

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
