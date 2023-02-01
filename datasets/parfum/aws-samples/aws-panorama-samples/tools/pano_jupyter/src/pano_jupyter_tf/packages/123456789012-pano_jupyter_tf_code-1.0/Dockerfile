# This Dockerfile fetches the image tagged latest by default
# To use a specific version of the image, refer to https://gallery.ecr.aws/panorama/panorama-application
# and tag the image in the Dockerfile with the version you're planning to use.



FROM public.ecr.aws/panorama/panorama-application


RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 \
    ca-certificates

COPY jetson-ota-public.key /etc/jetson-ota-public.key
RUN apt-key add /etc/jetson-ota-public.key

ARG CUDA=10.2
ARG RELEASE=r32.4

RUN echo "deb https://repo.download.nvidia.com/jetson/common $RELEASE main" >> /etc/apt/sources.list
RUN echo "deb https://repo.download.nvidia.com/jetson/t194 $RELEASE main" >> /etc/apt/sources.list


#
# install prerequisites - https://docs.nvidia.com/deeplearning/frameworks/install-tf-jetson-platform/index.html#prereqs
#
RUN apt-get update && \
 apt-get install -y --no-install-recommends \
       python3-dev \
       python3.7-dev \
       libpython3.7-dev \
       python3-pip \
       gfortran \
       build-essential \
       liblapack-dev \
       libblas-dev \
       libhdf5-serial-dev \
       hdf5-tools \
       libhdf5-dev \
       zlib1g-dev \
       zip \
       libjpeg8-dev

#RUN mkdir -p /usr/lib/python3.7/lib-dynload
#RUN cp /usr/lib/python3.7/lib-dynload/panoramasdk.so /usr/lib/python3.7/lib-dynload/panoramasdk.so

#
# Install Cuda, cuDNN, TensorRT
#
RUN CUDAPKG=$(echo $CUDA | sed 's/\./-/'); \
    apt-get update && apt-get install -y --no-install-recommends \
	cuda-libraries-$CUDAPKG \
	cuda-nvtx-$CUDAPKG \
	cuda-libraries-dev-$CUDAPKG \
	cuda-minimal-build-$CUDAPKG \
	cuda-license-$CUDAPKG \
	cuda-command-line-tools-$CUDAPKG \
    libcudnn8 \
    tensorrt \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

#Remove static libraries to save space
RUN rm -rf /usr/local/cuda-$CUDA/targets/aarch64-linux/lib/*.a
RUN rm -rf /usr/local/cuda-$CUDA/lib64/*.a
RUN rm -rf /usr/lib/aarch64-linux-gnu/libnvinfer_static.a
RUN rm -rf /usr/lib/aarch64-linux-gnu/libnvinfer_plugin_static.a

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

RUN echo "/usr/lib/aarch64-linux-gnu/tegra" >> /etc/ld.so.conf.d/nvidia-tegra.conf && \
    echo "/usr/lib/aarch64-linux-gnu/tegra-egl" >> /etc/ld.so.conf.d/nvidia-tegra.conf

#RUN rm /usr/share/glvnd/egl_vendor.d/50_mesa.json
RUN mkdir -p /usr/share/glvnd/egl_vendor.d/ && echo '\
{\
    "file_format_version" : "1.0.0",\
    "ICD" : {\
        "library_path" : "libEGL_nvidia.so.0"\
    }\
}' > /usr/share/glvnd/egl_vendor.d/10_nvidia.json

RUN mkdir -p /usr/share/egl/egl_external_platform.d/ && echo '\
{\
    "file_format_version" : "1.0.0",\
    "ICD" : {\
        "library_path" : "libnvidia-egl-wayland.so.1"\
    }\
}' > /usr/share/egl/egl_external_platform.d/nvidia_wayland.json

RUN echo "/usr/local/cuda-10.2/targets/aarch64-linux/lib" >> /etc/ld.so.conf.d/nvidia.conf

RUN ln -s /usr/local/cuda-$CUDA /usr/local/cuda && \
    ln -s /usr/local/cuda-$CUDA/targets/aarch64-linux/include /usr/local/cuda/include && \
    ln -s /usr/local/cuda-$CUDA/targets/aarch64-linux/lib /usr/local/cuda/lib64

ENV PATH /usr/local/cuda-$CUDA/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/cuda-$CUDA/targets/aarch64-linux/lib:${LD_LIBRARY_PATH}

ENV DEBIAN_FRONTEND=noninteractive
ARG HDF5_DIR="/usr/lib/aarch64-linux-gnu/hdf5/serial/"
ARG MAKEFLAGS=-j$(nproc)

RUN printenv

#
# Install tensorflow dependencies
#
RUN python3.7 -m pip install --no-cache-dir setuptools Cython wheel
RUN python3.7 -m pip install --no-cache-dir --verbose numpy
RUN python3.7 -m pip install --no-cache-dir --verbose h5py==2.10.0
RUN python3.7 -m pip install --no-cache-dir --verbose future==0.18.2 mock==3.0.5 h5py==2.10.0 keras_preprocessing==1.1.1 keras_applications==1.0.8 gast==0.2.2 futures protobuf==3.20.1 pybind11

#
# TensorFlow 2.4. See build instructions for building tensorflow wheel here: https://apivovarov.medium.com/run-tensorflow-2-object-detection-models-with-tensorrt-on-jetson-xavier-using-tf-c-api-e34548818ac6
#
COPY tensorflow-2.4.4-cp37-cp37m-linux_aarch64.whl .
ARG TENSORFLOW_WHL=tensorflow-2.4.4-cp37-cp37m-linux_aarch64.whl

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget

RUN python3.7 -m pip install --pre --verbose ${TENSORFLOW_WHL} && \
    rm ${TENSORFLOW_WHL}

#
# PyCUDA
#
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"
RUN echo "$PATH" && echo "$LD_LIBRARY_PATH"

RUN python3.7 -m pip install --no-cache-dir --verbose pycuda six
RUN pip3 install --upgrade numpy
#
# Run ld config
#
RUN ldconfig

#
# Set environment variables
# Note: These environment variables don't get persisted for runtime.
#
#ENV NVIDIA_VISIBLE_DEVICES all
#ENV NVIDIA_DRIVER_CAPABILITIES all

#CMD [ "/bin/bash" ]


















RUN apt-get update && apt-get install -y libglib2.0-0
RUN python3.7 -m pip install opencv-python boto3
RUN python3.7 -m pip install matplotlib




RUN apt-get install gcc --yes
RUN apt-get install python3.7-dev --yes
RUN pip3.7 install jupyterlab





COPY src /panorama


