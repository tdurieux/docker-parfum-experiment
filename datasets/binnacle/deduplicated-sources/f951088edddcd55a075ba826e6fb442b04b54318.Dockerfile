FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
      libgtest-dev \
      openmpi-bin \
      ca-certificates \
      wget \
      libgoogle-glog0v5 \
      liblmdb0 \
      libleveldb1v5 \
      libopencv-highgui2.4v5

RUN wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
RUN apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
RUN echo "deb https://apt.repos.intel.com/mkl all main" > /etc/apt/sources.list.d/intel-mkl.list
RUN apt-get install -y apt-transport-https
RUN apt-get update && apt-get install -y intel-mkl-gnu-rt-2018.3-222
RUN echo "/opt/intel/compilers_and_libraries_2018.3.222/linux/mkl/lib/intel64_lin/" > /etc/ld.so.conf.d/intel_mkl.conf
      
COPY lib/libcaffe2.so /usr/local/lib/libcaffe2.so
RUN ldconfig
COPY graphpipe-onnx /
ENTRYPOINT ["/graphpipe-onnx"]
