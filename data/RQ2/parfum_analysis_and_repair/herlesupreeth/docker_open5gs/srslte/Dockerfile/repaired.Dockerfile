# BSD 2-Clause License

# Copyright (c) 2020, Supreeth Herle
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

# Install updates and dependencies
RUN apt-get update && \
    apt-get -y --no-install-recommends install cmake libfftw3-dev libmbedtls-dev libboost-program-options-dev libconfig++-dev libsctp-dev git \
    libzmq3-dev libboost-system-dev libboost-test-dev libboost-thread-dev libqwt-qt5-dev qtbase5-dev \
    software-properties-common g++ make pkg-config libpython2-dev python-numpy swig libi2c-dev \
    libboost-program-options-dev libconfig++-dev && rm -rf /var/lib/apt/lists/*;

# Install SoapySDR and Lime Suite
RUN add-apt-repository -y ppa:myriadrf/drivers && \
    add-apt-repository -y ppa:pothosware/framework && \
    add-apt-repository -y ppa:pothosware/support && \
    apt update && \
    apt -y --no-install-recommends install limesuite liblimesuite-dev limesuite-udev limesuite-images soapysdr-tools soapysdr-module-lms7 && rm -rf /var/lib/apt/lists/*;

# UHD drivers for USRP
RUN add-apt-repository ppa:ettusresearch/uhd && \
    apt update && apt -y --no-install-recommends install libuhd-dev libuhd4.2.0 uhd-host && \
    uhd_images_downloader && rm -rf /var/lib/apt/lists/*;

# Get srsGUI, compile and install
RUN git clone https://github.com/srsran/srsGUI && \
    cd srsGUI/ && \
    mkdir build && cd build && \
    cmake ../ && make -j`nproc` && make install && ldconfig

#RUN apt-get update && apt-get install -y gdb libdw-dev

# Get srsLTE, compile and install
RUN git clone https://github.com/srsran/srsRAN.git && \
    cd srsRAN && \
    git checkout tags/release_22_04 && \
    mkdir build && cd build && \
    cmake ../ && make -j`nproc` && make install && \
    ldconfig

RUN cd srsRAN/build && srsran_install_configs.sh service

ENV UHD_IMAGES_DIR=/usr/share/uhd/images/

CMD /mnt/srslte/enb_init.sh && \
    cd /mnt/srslte && /usr/local/bin/srsenb

#gdb /usr/local/bin/srsenb
