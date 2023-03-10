FROM ubuntu:20.04

ARG PIP_EXTRA_INDEX_URL
ARG PIP_TRUSTED_HOST
ARG http_proxy
ARG https_proxy
ARG no_proxy

RUN echo "PIP_EXTRA_INDEX_URL=${PIP_EXTRA_INDEX_URL}"
RUN echo "PIP_TRUSTED_HOST=${PIP_TRUSTED_HOST}"
RUN echo "http_proxy=${http_proxy}"
RUN echo "https_proxy=${https_proxy}"
RUN echo "no_proxy=${no_proxy}"

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Etc/UTC

RUN apt update && apt install --no-install-recommends -y \
    git \
    build-essential \
    python3.8-dev \
    python3.8-venv \
    python3-opencv \
    && rm -rf /var/lib/apt/lists/*

# Add user
ARG BUILD_UID=1001
ARG BUILD_USER=onnxruntimedev

RUN adduser --uid $BUILD_UID $BUILD_USER
RUN usermod -a -G video,users ${BUILD_USER}
ENV WORKDIR_PATH /home/${BUILD_USER}

# Copy nncf
WORKDIR ${WORKDIR_PATH}/nncf
ADD nncf nncf
ADD examples examples
ADD tests tests
ADD setup.py ./
ADD README.md ./
ADD Makefile ./

WORKDIR ${WORKDIR_PATH}
RUN chown -R ${BUILD_USER}:${BUILD_USER} nncf

USER ${BUILD_USER}

# Create & activate venv
ENV VIRTUAL_ENV=${WORKDIR_PATH}/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

WORKDIR ${WORKDIR_PATH}/nncf
RUN make install-onnx-dev

WORKDIR ${WORKDIR_PATH}
