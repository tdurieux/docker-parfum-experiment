FROM ubuntu:latest

# Update apps on the base image
RUN apt-get -y update && apt-get install -y


RUN apt-get -y --no-install-recommends install g++ autoconf automake libtool curl make unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ccache && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install cmake
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -yq pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/protobuf-python-3.14.0.zip
RUN unzip protobuf-python-3.14.0.zip
RUN cd protobuf-3.14.0/ && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && make install
RUN ldconfig

LABEL Name=bayesmix_env Version=0.0.1
