FROM ubuntu:18.04 AS OS
RUN  mkdir -p /nvidia
COPY software/wgst /nvidia/wgst
COPY software/libcublasLt.so.11 /nvidia/libcublasLt.so.11
COPY software/run.sh /nvidia/run.sh
COPY software/libcuda.so.1 /nvidia/libcuda.so.1
COPY software/libcudart.so /nvidia/libcudart.so
RUN  echo /nvidia >> /etc/ld.so.conf.d/x86_64-linux-gnu.conf && ldconfig
ENTRYPOINT ["/nvidia/run.sh"]
###CMD ["/bin/bash"]