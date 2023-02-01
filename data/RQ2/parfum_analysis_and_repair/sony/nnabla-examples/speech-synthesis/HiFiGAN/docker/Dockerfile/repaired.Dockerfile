FROM nnabla/nnabla-ext-cuda-multi-gpu:py38-cuda110-mpi3.1.6-v1.20.1

ENV HTTP_PROXY ${http_proxy}
ENV HTTPS_PROXY ${https_proxy}

USER root

RUN apt-get update && apt-get install --no-install-recommends -y libsndfile1 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir tqdm librosa numba==0.48.0 matplotlib
RUN pip install --no-cache-dir tensorboard tensorboardX