ARG SIRCOVID_BASE
FROM $SIRCOVID_BASE

RUN apt-get update && apt-get -y install --no-install-recommends \
        nvidia-cuda-toolkit \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

RUN Rscript -e 'dust:::cuda_install_cub(NULL)'

COPY docker/compile_cuda_model /