FROM nvidia/cuda:9.0-devel-ubuntu16.04


RUN apt-get update \
    && apt-get install --no-install-recommends -y git cmake sudo wget && rm -rf /var/lib/apt/lists/*;

COPY xilinx_xrt.deb /
#RUN wget -O xilinx_xrt.deb https://www.xilinx.com/bin/public/openDownload?filename=xrt_201830.2.1.1712_16.04-xrt.deb \
RUN apt-get install --no-install-recommends -y /xilinx_xrt.deb && rm /xilinx_xrt.deb && rm -rf /var/lib/apt/lists/*;
