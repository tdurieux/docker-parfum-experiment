ARG DUST_BASE
FROM $DUST_BASE

RUN apt-get update && apt-get -y install --no-install-recommends \
        nvidia-cuda-toolkit \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

RUN Rscript -e 'dust:::cuda_install_cub(NULL)'

COPY docker/compile_gpu_model /