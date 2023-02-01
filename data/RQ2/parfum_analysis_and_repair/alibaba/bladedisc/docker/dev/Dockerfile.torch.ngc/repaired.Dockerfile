ARG BASEIMAGE=nvcr.io/nvidia/pytorch:21.11-py3
FROM ${BASEIMAGE}

COPY docker/scripts /install/scripts

RUN mkdir -p /usr/local/TensorRT && \
    ln -s /usr/include/x86_64-linux-gnu/ /usr/local/TensorRT/include && \
    ln -s /lib/x86_64-linux-gnu/ /usr/local/TensorRT/lib

RUN cp /install/scripts/ubuntu20.04.list /etc/apt/sources.list && \
    apt-get update

RUN apt-get install --no-install-recommends -y git curl vim libssl-dev wget unzip openjdk-11-jdk && \
    pip3 install --no-cache-dir --upgrade pip && \
    bash /install/scripts/install-bazel.sh && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install virtualenv
RUN python3 -m pip install 'git+https://github.com/facebookresearch/detectron2.git'

ENV PATH="/opt/cmake/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/TensorRT/lib/:${LD_LIBRARY_PATH}"
