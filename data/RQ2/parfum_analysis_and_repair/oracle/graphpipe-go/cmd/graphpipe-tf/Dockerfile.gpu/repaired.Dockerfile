FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
COPY graphpipe-tf /
COPY lib/libiomp5.so /usr/local/lib
COPY lib/libmklml_intel.so /usr/local/lib
COPY lib/libtensorflow.so /usr/local/lib
RUN ldconfig
ENTRYPOINT ["/graphpipe-tf"]
