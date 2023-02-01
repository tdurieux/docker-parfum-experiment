FROM nvidia/opencl

RUN mkdir -p /src

# install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y lsb-core wget && rm -rf /var/lib/apt/lists/*;

# install mdt
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && add-apt-repository ppa:robbert-harms/cbclab && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y python3-mdt python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir tatsu==4.2.6
