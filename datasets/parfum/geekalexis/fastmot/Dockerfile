ARG TRT_IMAGE_VERSION=20.09
FROM nvcr.io/nvidia/tensorrt:${TRT_IMAGE_VERSION}-py3

ARG TRT_IMAGE_VERSION
ARG OPENCV_VERSION=4.1.1
ARG APP_DIR=/usr/src/app
ARG SCRIPT_DIR=/opt/tensorrt/python
ARG DEBIAN_FRONTEND=noninteractive

ENV HOME=${APP_DIR}
ENV TZ=America/Los_Angeles

ENV OPENBLAS_MAIN_FREE=1
ENV OPENBLAS_NUM_THREADS=1
ENV NO_AT_BRIDGE=1

# Install OpenCV and FastMOT dependencies
RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
    wget unzip tzdata \
    build-essential cmake pkg-config \
    libgtk-3-dev libcanberra-gtk3-module \
    libjpeg-dev libpng-dev libtiff-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    libv4l-dev libxvidcore-dev libx264-dev \
    gfortran libatlas-base-dev \
    python3-dev \
    gstreamer1.0-tools \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    gstreamer1.0-libav \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    libtbb2 libtbb-dev libdc1394-22-dev && \
    pip install -U --no-cache-dir setuptools pip && \
    pip install --no-cache-dir numpy==1.18.0

# Build OpenCV
WORKDIR ${HOME}
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
    unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip && \
    mv opencv-${OPENCV_VERSION} OpenCV && \
    wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip && \
    unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip && \
    mv opencv_contrib-${OPENCV_VERSION} OpenCV/opencv_contrib

# If you have issues with GStreamer, set -DWITH_GSTREAMER=OFF and -DWITH_FFMPEG=ON
WORKDIR ${HOME}/OpenCV/build
RUN cmake \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DOPENCV_EXTRA_MODULES_PATH=${HOME}/OpenCV/opencv_contrib/modules \
    -DINSTALL_PYTHON_EXAMPLES=ON \
    -DINSTALL_C_EXAMPLES=OFF \
    -DBUILD_opencv_python2=OFF \
    -DBUILD_TESTS=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DBUILD_EXAMPLES=ON \
    -DBUILD_PROTOBUF=OFF \
    -DENABLE_FAST_MATH=ON \
    -DWITH_TBB=ON \
    -DWITH_LIBV4L=ON \
    -DWITH_CUDA=OFF \
    -DWITH_GSTREAMER=ON \
    -DWITH_GSTREAMER_0_10=OFF \
    -DWITH_FFMPEG=OFF .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    rm -rf ${HOME}/OpenCV && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove

# Install Python dependencies
WORKDIR ${APP_DIR}/FastMOT
COPY requirements.txt .

# Specify your GPU compute with --build-arg for CuPy (e.g. "arch=compute_75,code=sm_75")
ARG CUPY_NVCC_GENERATE_CODE

# TensorFlow < 2 is not supported in ubuntu 20.04
RUN if [[ -z ${CUPY_NVCC_GENERATE_CODE} ]]; then \
        echo "CUPY_NVCC_GENERATE_CODE not set, building CuPy for all architectures (slower)"; \
    fi && \
    if dpkg --compare-versions ${TRT_IMAGE_VERSION} ge 20.12; then \
        CUPY_NUM_BUILD_JOBS=$(nproc) pip install --no-cache-dir -r <(grep -ivE "tensorflow" requirements.txt); \
    else \
        dpkg -i ${SCRIPT_DIR}/*-tf_*.deb && \
        CUPY_NUM_BUILD_JOBS=$(nproc) pip install --no-cache-dir -r requirements.txt; \
    fi

# ------------------------------------  Extras Below  ------------------------------------

# Stop the container (changes are kept)
# docker stop $(docker ps -ql)

# Start the container
# docker start -ai $(docker ps -ql)

# Delete the container
# docker rm $(docker ps -ql)

# Save changes before deleting the container
# docker commit $(docker ps -ql) fastmot:latest
