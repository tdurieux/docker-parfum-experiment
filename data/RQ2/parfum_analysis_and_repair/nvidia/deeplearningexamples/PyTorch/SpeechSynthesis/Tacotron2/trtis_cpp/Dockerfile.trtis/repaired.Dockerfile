ARG TRTIS_IMAGE=nvcr.io/nvidia/tensorrtserver:20.02-py3

FROM ${TRTIS_IMAGE}

RUN mkdir -p /workspace/trt-tacotron2-waveglow
WORKDIR /workspace/trt-tacotron2-waveglow

# Download custom backend SDK
RUN wget https://github.com/NVIDIA/tensorrt-inference-server/releases/download/v1.11.0/v1.11.0_ubuntu1804.custombackend.tar.gz
RUN tar xf v1.11.0_ubuntu1804.custombackend.tar.gz && mv custom-backend-sdk ./trtis_sdk && rm v1.11.0_ubuntu1804.custombackend.tar.gz

# install cmake
RUN apt-get update && apt-get install --no-install-recommends -qy cmake && apt-get clean && rm -rf /var/lib/apt/lists/*;

# build the source code
ADD src/ "./src"
ADD CMakeLists.txt "./"
ADD configure "./"

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --trtis
RUN make

ARG TACOTRON2_MODEL="tacotron.json"
ARG WAVEGLOW_MODEL="waveglow.onnx"
ARG DENOISER_MODEL="denoiser.json"

RUN mkdir -p "/models" "/engines"

ADD "${TACOTRON2_MODEL}" /models/
ADD "${WAVEGLOW_MODEL}" /models/
ADD "${DENOISER_MODEL}" /models/

ADD model-config/tacotron2waveglow /models/tacotron2waveglow
RUN mkdir -p /models/tacotron2waveglow/1
RUN cp -v "./build/lib/libtt2i_trtis.so" /models/tacotron2waveglow/1/

ADD scripts "./scripts"
