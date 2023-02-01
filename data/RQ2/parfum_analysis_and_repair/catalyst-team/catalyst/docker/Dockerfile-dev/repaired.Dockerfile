# pytorch
ARG PYTORCH_TAG
FROM pytorch/pytorch:${PYTORCH_TAG:-latest}

# apex
ARG CATALYST_APEX
# extras
ARG CATALYST_DEV
ARG CATALYST_CV
ARG CATALYST_ML
ARG CATALYST_OPTUNA
ARG CATALYST_ONNX
ARG CATALYST_ONNX_GPU

#RUN apt-get update && apt-get install -y software-properties-common \
#    && rm -rf /var/lib/apt/lists/* \
#    && add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main" \
#    && apt-get update && apt-get install -y \
#         build-essential \
#         libsm6 \
#         libxext6 \
#         libfontconfig1 \
#         libxrender1 \
#         libswscale-dev \
#         libtbb2 \
#         libtbb-dev \
#         libjpeg-dev \
#         libpng-dev \
#         libtiff-dev \
#         libjasper-dev \
#         libavformat-dev \
#         libpq-dev \
#         libturbojpeg \
#        git \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*