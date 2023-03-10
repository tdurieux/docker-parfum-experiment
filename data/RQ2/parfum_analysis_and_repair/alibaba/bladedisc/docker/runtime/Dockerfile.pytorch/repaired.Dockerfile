ARG BASEIMAGE=nvidia/cuda:11.0-cudnn8-devel-ubuntu18.04
FROM ${BASEIMAGE}

ENV DEBIAN_FRONTEND noninteractive
ARG DEVICE=cu110
ADD ./docker/scripts /install/scripts
RUN bash /install/scripts/find-fastest-apt.sh && \
        apt-get install --no-install-recommends -y -qq wget curl unzip && rm -rf /var/lib/apt/lists/*;
RUN bash /install/scripts/install-tensorrt.sh "${DEVICE}"
RUN bash /install/scripts/patch-cuda.sh "${DEVICE}"

ADD ./build/torch_blade*.whl  /install/python/

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y python3.6 python3-pip protobuf-compiler libprotobuf-dev cmake \
    && ln -s /usr/bin/python3.6 /usr/bin/python \
    && python3.6 -m pip install pip --upgrade \
    && python3.6 -m pip install onnx==1.11.0 \
    && python3.6 -m pip install /install/python/torch_blade*.whl -f https://download.pytorch.org/whl/torch_stable.html && rm -rf /var/lib/apt/lists/*;

ENV PATH /usr/bin:$PATH
ENV LD_LIBRARY_PATH="/usr/local/TensorRT/lib/:${LD_LIBRARY_PATH}"
