# Copyright (c) 2019 Christof Ruch. All rights reserved.
#
# Dual licensed: Distributed under Affero GPL license by default, an MIT license is available for purchase

FROM ubuntu:latest

RUN apt-get update && apt-get -y --no-install-recommends install unzip less g++ make && rm -rf /var/lib/apt/lists/*;

# Stuff required to use JUCE in the basic version for the server
RUN apt-get -y --no-install-recommends install libasound2-dev libcurl4-openssl-dev pkg-config && rm -rf /var/lib/apt/lists/*;

# Add much more stuff to be used by the Client
RUN apt-get -y --no-install-recommends install libfreetype6-dev libjack-dev libx11-dev mesa-common-dev libgl1-mesa-dev libglew-dev libgtk-3-dev webkit2gtk-4.0 && rm -rf /var/lib/apt/lists/*;

# Stuff required by my code
RUN apt-get -y --no-install-recommends install libtbb-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

COPY curl-7.67.0.tar.gz /root
RUN cd /root && tar -xzf curl-7.67.0.tar.gz && cd curl-7.67.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-ssl && make -j4 && make install && ldconfig && rm curl-7.67.0.tar.gz

COPY cmake-3.15.5.tar.gz /root
RUN cd /root && tar -xzf cmake-3.15.5.tar.gz && cd cmake-3.15.5 && ./bootstrap && make -j4 && make install && rm cmake-3.15.5.tar.gz

RUN apt-get install --no-install-recommends -y tofrodos && rm -rf /var/lib/apt/lists/*;
COPY run_make.sh /root
RUN fromdos /root/run_make.sh
RUN chmod +x /root/run_make.sh

ENTRYPOINT /root/run_make.sh

# Build the container via
#
# docker build .
#
# and then run it with
#
# docker run --volume=//d/development/jammernetz:/src -it -p 7777:7777/udp --entrypoint=/bin/bash --rm <containerID>
#
