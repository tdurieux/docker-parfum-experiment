FROM nvidia/cuda:11.2.2-devel-ubuntu20.04

ENV ARGOS_DEVICE_TYPE cuda
ARG with_models=true
ARG models=

WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
    && apt-get -qqq install --no-install-recommends -y libicu-dev libaspell-dev libcairo2 libcairo2-dev pkg-config gcc g++ python3.8-dev python3-pip libpython3.8-dev\
    && apt-get clean \
    && rm -rf /var/lib/apt && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip

COPY . .

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN pip3 install --no-cache-dir torch==1.12.0+cu116 -f https://download.pytorch.org/whl/torch_stable.html

RUN if [ "$with_models" = "true" ]; then \
    pip3 install --no-cache-dir -e .; \

    if [ ! -z "$models" ]; then \
    ./install_models.py --load_only_lang_codes "$models";   \
    else \
    ./install_models.py;  \
    fielse \
    ./install_models.py;  \
    fi \
    fi

# Install package from source code
RUN pip3 install --no-cache-dir . \
    && pip3 cache purge

# Depending on your cuda install you may need to uncomment this line to allow the container to access the cuda libraries
# See: https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#post-installation-actions
# ENV LD_LIBRARY_PATH=/usr/local/cuda/lib:/usr/local/cuda/lib64

EXPOSE 5000
ENTRYPOINT [ "libretranslate", "--host", "0.0.0.0" ]
