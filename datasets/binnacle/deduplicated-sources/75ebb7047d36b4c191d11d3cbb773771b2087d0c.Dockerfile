FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/lib
ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:

RUN apt-get update && apt-get install -y --no-install-recommends \
      libgtest-dev \
      openmpi-bin \
      wget \
      libgoogle-glog0v5 \
      liblmdb0 \
      libleveldb1v5 \
      libopencv-core2.4v5 \
      libopencv-highgui2.4v5
      
RUN wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
RUN apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
RUN sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list'
RUN apt-get update && apt-get install -y intel-mkl-64bit-2018.3-051
RUN echo "/opt/intel/compilers_and_libraries_2018.3.222/linux/mkl/lib/intel64_lin/" > /etc/ld.so.conf.d/intel_mkl.conf

COPY lib/libcaffe2.so /usr/local/lib/libcaffe2.so
COPY lib/libcaffe2_gpu.so /usr/local/lib/libcaffe2_gpu.so
COPY graphpipe-onnx /
ENTRYPOINT ["/graphpipe-onnx"]
