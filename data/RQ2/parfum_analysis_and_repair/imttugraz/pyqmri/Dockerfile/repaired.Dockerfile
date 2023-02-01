#Download base image python buster
FROM nvidia/opencl
USER root

ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt-get update
RUN apt install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:deadsnakes/ppa

RUN apt-get install --no-install-recommends -y python3.8-dev && \
    apt-get install --no-install-recommends -y python3-pip && \
    apt-get install --no-install-recommends -y python3-tk && \
    apt-get install --no-install-recommends -y ocl-icd* opencl-headers && \
    apt-get install --no-install-recommends -y libclfft* && \
    apt-get install --no-install-recommends -y git && \
    apt-get install --no-install-recommends -y pocl-opencl-icd && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libhdf5-dev && rm -rf /var/lib/apt/lists/*;

RUN python3.8 -m pip install --upgrade pip

RUN python3.8 -m pip install cython
RUN python3.8 -m pip install mako
RUN python3.8 -m pip install pybind11
RUN python3.8 -m pip install pyopencl

RUN git clone https://github.com/geggo/gpyfft.git &&\
    python3.8 -m pip install gpyfft/. &&\
    python3.8 -m pip install pytest &&\
    python3.8 -m pip install pytest-cov &&\
    python3.8 -m pip install pylint &&\
    python3.8 -m pip install pylint_junit &&\
    python3.8 -m pip install pytest-integration
