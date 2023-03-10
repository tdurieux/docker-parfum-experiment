FROM nvidia/cuda:9.0-devel-ubuntu16.04
MAINTAINER Sanjeev Mehrotra <sanjeevm@microsoft.com>

RUN apt-get -y update && apt-get -y --no-install-recommends install cuda-samples-9.0 && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/local/cuda-9.0/samples/1_Utilities/p2pBandwidthLatencyTest
RUN make
CMD /usr/local/cuda-9.0/samples/1_Utilities/p2pBandwidthLatencyTest/p2pBandwidthLatencyTest

