FROM nnabla/nnabla-ext-cuda-multi-gpu:py38-cuda110-mpi3.1.6-v1.20.0

ENV HTTP_PROXY ${http_proxy}
ENV HTTPS_PROXY ${https_proxy}

USER root

RUN apt-get update
RUN apt-get install --no-install-recommends -y libsndfile1 git sox && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-dev python3.8-dev \
     build-essential libssl-dev libffi-dev \
     libxml2-dev libxslt1-dev zlib1g-dev \
     python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir tqdm librosa numba==0.48.0 matplotlib sox g2p_en pyworld tgt
RUN pip install --no-cache-dir tensorboard tensorboardX
RUN pip install --no-cache-dir torch torchvision

# for development
RUN pip install --no-cache-dir flake8 pycodestyle pytest pytest-cov
