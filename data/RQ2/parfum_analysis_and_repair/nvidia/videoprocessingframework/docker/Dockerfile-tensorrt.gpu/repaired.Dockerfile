FROM docker.io/nvidia/cuda:11.2.0-cudnn8-devel-ubuntu20.04 as build

ENV POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_VERSION=1.1.7

ENV PATH="/opt/.venv/bin:$POETRY_HOME/bin:$PATH" \
    PYTHON_BINARY="/opt/.venv/bin/python"

RUN apt update && DEBIAN_FRONTEND=noninteractive \
    apt --no-install-recommends -y install \
    git wget cmake \
    build-essential curl \
    libavcodec-dev libavformat-dev libswscale-dev \
    libxvidcore-dev x264 libx264-dev libfaac-dev \
    libmp3lame-dev libtheora-dev libvorbis-dev \
    python3.8 python3-pip python3.8-venv && \
    rm -rf /var/lib/apt/lists/*

# https://python-poetry.org/docs/
WORKDIR $POETRY_HOME
RUN curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python3

WORKDIR /opt

COPY docker/Makefile docker/Makefile
COPY poetry.lock poetry.lock
COPY pyproject.toml pyproject.toml

# Build poetry virtual environment
RUN make -f docker/Makefile build_env EXTRAS=vpf-tensorrt

# Build vpf
COPY . .

RUN make -f docker/Makefile vpf_built \
                            PYTHON_BINARY=$PYTHON_BINARY \
                            VIDEO_CODEC_SDK=/opt/Video_Codec_SDK \
                            GEN_PYTORCH_EXT=1

FROM nvcr.io/nvidia/tensorrt:21.08-py3

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
    git build-essential libbsd0 \
    wget cmake ffmpeg libtbb-dev \
    libjpeg8-dev libpng-dev libtiff-dev \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
    libdc1394-22-dev libssl-dev \
    libxine2-dev libv4l-dev \
    libboost-all-dev libdc1394-22-dev \
    python3.8 python3-pip python3.8-venv curl && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt

COPY --from=build /opt/dist /opt/dist
COPY --from=build /opt/poetry /opt/poetry
# Normally we'd reinstall the enviroment but pycuda is built with cuda headers
# which are not available in the nvidia runtime image
COPY --from=build /opt/.venv /opt/.venv
COPY . .

ENV POETRY_HOME="/opt/poetry"

ENV PATH="/opt/.venv/bin:$POETRY_HOME/bin:$PATH" \
    LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/dist/bin:/opt/.venv/lib/python3.8/site-packages/torch/lib" \
    PYTHONPATH=/opt/.venv/bin:/opt/dist/bin

ENTRYPOINT ["/bin/bash"]
