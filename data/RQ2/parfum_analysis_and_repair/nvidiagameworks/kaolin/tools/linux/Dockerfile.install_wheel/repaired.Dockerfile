ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN if [ -f /etc/apt/sources.list.d/cuda.list ]; then \
        rm /etc/apt/sources.list.d/cuda.list; \
    fi \
    && if [ -f /etc/apt/sources.list.d/nvidia-ml.list ]; then \
        rm /etc/apt/sources.list.d/nvidia-ml.list; \
    fi

WORKDIR /kaolin

ARG WHEEL_NAME

COPY ./package.json ./package-lock.json ./${WHEEL_NAME} ./
COPY ./examples ./examples
COPY ./tests ./tests
COPY ./tools ./tools
RUN apt-get -y update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libgl1-mesa-dev \
        libgles2-mesa-dev \
        libegl1-mesa-dev \
        git \
        pkg-config \
        libglvnd0 \
        libgl1 \
        libglx0 \
        libegl1 \
        libgles2 \
        libglvnd-dev \
        cmake \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# for GLEW
ENV LD_LIBRARY_PATH /usr/lib64:$LD_LIBRARY_PATH

# nvidia-container-runtime
#ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics

# Default pyopengl to EGL for good headless rendering support
ENV PYOPENGL_PLATFORM egl

## Install Dash3D Requirements ###
RUN conda install -c conda-forge nodejs==16.13.0 \
    && conda clean --all --force-pkgs-dirs
RUN npm install -g npm@8.5.4 && npm cache clean --force;
RUN npm install && npm cache clean --force;

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir imageio imageio-ffmpeg

RUN cd /tmp && \
    git clone https://github.com/NVlabs/nvdiffrast && \
    cd nvdiffrast && \
    cp ./docker/10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json && \
    pip install --no-cache-dir .

RUN pip install --no-cache-dir ./${WHEEL_NAME}
