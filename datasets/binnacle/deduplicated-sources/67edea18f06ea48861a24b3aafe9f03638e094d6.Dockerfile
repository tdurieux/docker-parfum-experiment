ARG BASE_TAG=staging

FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu16.04 AS nvidia
FROM gcr.io/kaggle-images/python-tensorflow-whl:1.12.0-py36 as tensorflow_whl
FROM gcr.io/kaggle-images/python:${BASE_TAG}

ADD clean-layer.sh  /tmp/clean-layer.sh
RUN chmod +x /tmp/clean-layer.sh

# Cuda support
COPY --from=nvidia /etc/apt/sources.list.d/cuda.list /etc/apt/sources.list.d/
COPY --from=nvidia /etc/apt/sources.list.d/nvidia-ml.list /etc/apt/sources.list.d/
COPY --from=nvidia /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d/cuda.gpg

# Ensure the cuda libraries are compatible with the custom Tensorflow wheels.
# TODO(b/120050292): Use templating to keep in sync or COPY installed binaries from it.
ENV CUDA_VERSION=9.2.148
ENV CUDA_PKG_VERSION=9-2=$CUDA_VERSION-1
LABEL com.nvidia.volumes.needed="nvidia_driver"
LABEL com.nvidia.cuda.version="${CUDA_VERSION}"
ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
# The stub is useful to us both for built-time linking and run-time linking, on CPU-only systems.
# When intended to be used with actual GPUs, make sure to (besides providing access to the host
# CUDA user libraries, either manually or through the use of nvidia-docker) exclude them. One
# convenient way to do so is to obscure its contents by a bind mount:
#   docker run .... -v /non-existing-directory:/usr/local/cuda/lib64/stubs:ro ...
ENV LD_LIBRARY_PATH="/usr/local/nvidia/lib64:/usr/local/cuda/lib64:/usr/local/cuda/lib64/stubs"
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_REQUIRE_CUDA="cuda>=9.2"
RUN apt-get update && apt-get install -y --no-install-recommends \
      cuda-cupti-$CUDA_PKG_VERSION \
      cuda-cudart-$CUDA_PKG_VERSION \
      cuda-cudart-dev-$CUDA_PKG_VERSION \
      cuda-libraries-$CUDA_PKG_VERSION \
      cuda-libraries-dev-$CUDA_PKG_VERSION \
      cuda-nvml-dev-$CUDA_PKG_VERSION \
      cuda-minimal-build-$CUDA_PKG_VERSION \
      cuda-command-line-tools-$CUDA_PKG_VERSION \
      libcudnn7=7.4.1.5-1+cuda9.2 \
      libcudnn7-dev=7.4.1.5-1+cuda9.2 \
      libnccl2=2.3.7-1+cuda9.2 \
      libnccl-dev=2.3.7-1+cuda9.2 && \
    ln -s /usr/local/cuda-9.2 /usr/local/cuda && \
    ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 && \
    /tmp/clean-layer.sh

# Reinstall packages with a separate version for GPU support
# Tensorflow
COPY --from=tensorflow_whl /tmp/tensorflow_gpu/*.whl /tmp/tensorflow_gpu/
RUN pip uninstall -y tensorflow && \
    pip install /tmp/tensorflow_gpu/tensorflow*.whl && \
    rm -rf /tmp/tensorflow_gpu && \
    conda uninstall -y pytorch-cpu torchvision-cpu && \
    conda install -y pytorch torchvision cudatoolkit=9.2 -c pytorch && \
    pip uninstall -y mxnet && \
    # b/126259508 --no-deps prevents numpy from being downgraded.
    pip install --no-deps mxnet-cu92 && \
    /tmp/clean-layer.sh

# Install GPU-only packages
RUN pip install pycuda && \
    pip install cupy-cuda92 && \
    pip install pynvrtc && \
    /tmp/clean-layer.sh

# Re-add TensorBoard Jupyter extension patch
ADD patches/tensorboard/notebook.py /opt/conda/lib/python3.6/site-packages/tensorboard/notebook.py

RUN apt-get install -y openssh-server sudo screen

# netcore 2.0

RUN apt-get install -y software-properties-common
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
RUN apt-get update && apt-get install libicu55
RUN apt-get install -y dotnet-sdk-2.2
# RUN apt-get install -y aspnetcore-runtime-2.2  dotnet-runtime-2.2 dotnet-runtime-deps-2.2 dotnet-sdk-2.2

# Gdal
# RUN add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
# RUN apt update -y
# RUN apt install -y libgdal-dev gdal-bin python-gdal python3-gdal vim htop 
# RUN conda remove -y ipykernel
# RUN conda install -y gdal ipykernel jupyterlab 
# RUN conda install -y gdal
# RUN conda update -y conda
# RUN conda update -y jupyter 
# RUN conda install -c conda-forge jupyterlab
# RUN conda create -n ipykernel_py2 python=2 ipykernel
# RUN conda create -n ipykernel_py3 python=3 ipykernel
# RUN source activate ipykernel_py2
# RUN source activate ipykernel_py3
# RUN python -m ipykernel install --user
RUN apt-get update -y && apt-get install -y python3-pycurl locales ssh-askpass  python3-tk python3-pip python3-dev
RUN pip install --upgrade pip 
RUN pip install mechanize
RUN apt-get install -y firefox unzip xvfb libxi6 libgconf-2-4 default-jdk
RUN pip install selenium PyVirtualDisplay
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.14.0/geckodriver-v0.14.0-linux64.tar.gz -O /tmp/geckodriver.tar.gz && tar -C /opt -xzf /tmp/geckodriver.tar.gz

# project file
RUN pip3 uninstall pil
RUN pip3 install youtube-dl face_recognition glob3 opencv-python pillow



ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
