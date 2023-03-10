FROM ubuntu:20.04
MAINTAINER Charlie Lewis <clewis@iqt.org>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -yq \
     cmake \
     libuhd-dev \
     uhd-host \
     libboost-program-options-dev \
     libvolk2-dev \
     libfftw3-dev \
     libmbedtls-dev \
     libsctp-dev \
     libconfig++-dev \
     curl \
     unzip \
     libzmq3-dev \
     build-essential \
     git \
     ca-certificates \
     iproute2 \
     libpcsclite-dev \
     lksctp-tools \
     libtecla-dev \
     libedit-dev \
     libusb-1.0-0-dev \
     wget \
     tcpdump \
     net-tools \
     iputils-ping \
     iperf \
     iperf3 && rm -rf /var/lib/apt/lists/*;
WORKDIR /root
COPY add_default_route.sh /root/add_default_route.sh
COPY start_srsue.sh /root/start_srsue.sh

# pin all bladeRF/srsLTE stack reproducibility
RUN git clone https://github.com/Nuand/bladeRF.git -b 2021.03
RUN git clone https://github.com/pothosware/SoapySDR -b soapy-sdr-0.7.2
RUN git clone https://github.com/pothosware/SoapyBladeRF.git -b soapy-bladerf-0.4.1
RUN git clone https://github.com/srsLTE/srsLTE.git -b release_20_10_1
# pinned FPGA/firmware (see "latest" on fpga/firmware pages)
RUN wget https://www.nuand.com/fpga/v0.12.0/hostedxA9.rbf
RUN wget https://www.nuand.com/fx3/bladeRF_fw_v2.4.0.img

# https://github.com/Nuand/bladeRF
RUN mkdir -p /root/bladeRF/host/build
WORKDIR /root/bladeRF/host/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DINSTALL_UDEV_RULES=ON -DBLADERF_GROUP=plugdev -DENABLE_BACKEND_LIBUSB=ON .. && make -j && make install && ldconfig
# Should detect bladeRF:
# bladeRF-cli -p
# bladeRF-cli -e info -e version
# if firmware upgrade indicated:
# bladeRF-cli -f <firmware_file>

# https://github.com/pothosware/SoapyBladeRF/wiki
RUN mkdir -p /root/SoapySDR/build
WORKDIR /root/SoapySDR/build
RUN cmake ../ && make -j && make install
RUN mkdir -p /root/SoapyBladeRF/build
WORKDIR /root/SoapyBladeRF/build
RUN cmake ../ && make -j && make install

# https://github.com/pothosware/SoapyBladeRF/wiki
# Should detect bladeRF:
# SoapySDRUtil --probe="driver=bladerf"

# srsLTE now has bladeRF driver available
RUN mkdir -p /root/srsLTE/build
RUN mkdir /config
WORKDIR /root/srsLTE/build
RUN cmake ../ && make -j && make install && ldconfig

ENTRYPOINT ["/bin/sh"]
