FROM nvidia/cuda:11.6.2-cudnn8-devel-ubuntu20.04

RUN apt-get update && apt-get install --no-install-recommends -y \
  git \
  python3 \
  python3-pip \
  && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade "jax[cuda]" -f https://storage.googleapis.com/jax-releases/jax_releases.html \
  && pip install --no-cache-dir -q \
  git+https://github.com/borisdayma/dalle-mini.git \
  git+https://github.com/patil-suraj/vqgan-jax.git

RUN pip install --no-cache-dir jupyter

WORKDIR /workspace

