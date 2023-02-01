FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    cython \
    locales \
    python-concurrent.futures \
    python-gdcm \
    python-matplotlib \
    python-nibabel \
    python-numpy \
    python-pil \
    python-psutil \
    python-scipy \
    python-serial \
    python-skimage \
    python-vtk6 \
    python-vtkgdcm \
    python-wxgtk3.0 && rm -rf /var/lib/apt/lists/*;

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /usr/local/app

COPY . .

RUN python setup.py build_ext --inplace
