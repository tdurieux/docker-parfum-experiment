# default cpu version base
ARG base_tag=ubuntu:bionic-20200219

From ${base_tag}
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:$LD_LIBRARY_PATH

RUN mkdir -p /app
COPY . /app
WORKDIR /app

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && rm -f /etc/apt/sources.list.d/cuda.list \
    && rm -f /etc/apt/sources.list.d/nvidia-ml.list \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update --fix-missing \
    && apt-get install --no-install-recommends -y python3 \
    python3-pip wget \
    libglib2.0-0 libsm6 \
    libxext6 libxrender1 \
    && pip3 install --no-cache-dir --upgrade pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && cd /app/data \
    && ./prepare_model.sh \
    && cd - \
    && mkdir tmp

ENV TF_XLA_FLAGS --tf_xla_cpu_global_jit
RUN pip3 install --no-cache-dir -r /app/requirements.txt -i https://mirrors.aliyun.com/pypi/simple/

EXPOSE 80
CMD ["python3", "server.py"]
