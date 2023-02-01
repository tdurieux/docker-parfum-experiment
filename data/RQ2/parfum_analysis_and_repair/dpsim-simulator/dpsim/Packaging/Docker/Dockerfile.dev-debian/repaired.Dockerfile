FROM debian:10

RUN apt-get update -y

# Toolchain
RUN apt-get -y --no-install-recommends install \
	gcc g++ clang \
	git \
	make cmake pkg-config \
	python3-pip \
	wget && rm -rf /var/lib/apt/lists/*;

# Tools needed for developement
RUN apt-get -y --no-install-recommends install \
	doxygen graphviz \
	gdb && rm -rf /var/lib/apt/lists/*;

# Dependencies
RUN apt-get update -y && apt-get -y --no-install-recommends install \
	python3-dev \
	libeigen3-dev \
	libxml2-dev \
	libgraphviz-dev \
	libgsl-dev \
	libspdlog-dev \
	pybind11-dev && rm -rf /var/lib/apt/lists/*;

## Build & Install fmtlib
RUN cd /tmp && \
	git clone --recursive https://github.com/fmtlib/fmt.git && \
	mkdir -p fmt/build && cd fmt/build && \
	git checkout 6.1.2  && \
	cmake -DBUILD_SHARED_LIBS=ON .. && \
	make -j$(nproc) install

## Build & Install spdlog
RUN cd /tmp && \
	git clone --recursive https://github.com/gabime/spdlog.git && \
	mkdir -p spdlog/build && cd spdlog/build && \
	git checkout v1.5.0 && \
	cmake -DSPDLOG_BUILD_SHARED=ON .. && \
	make -j$(nproc) install

# Build & Install sundials
RUN cd /tmp && \
	git clone --recursive https://github.com/LLNL/sundials.git && \
	mkdir -p sundials/build && cd sundials/build && \
	git checkout v3.2.1 && \
	cmake -DCMAKE_BUILD_TYPE=Release ..  && \
	make -j$(nproc) install

# Install some debuginfos
#RUN dnf -y debuginfo-install \
#	python3

# CIMpp and VILLAS are installed here
# ENV LD_LIBRARY_PATH="/usr/local/lib64:${LD_LIBRARY_PATH}"

# minimal VILLAS dependencies
RUN apt-get -y --no-install-recommends install \
    libssl-dev \
    uuid-dev \
	libcurl4-gnutls-dev \
    libjansson-dev && rm -rf /var/lib/apt/lists/*;

# Install libwebsockets-dev from source
RUN cd /tmp && \
	git clone https://github.com/warmcat/libwebsockets.git && \
	cd libwebsockets && git checkout v4.1.6 && \
	mkdir build && cd build && \
	cmake .. && make -j$(nproc) install && \
	rm -rf /tmp/libwebsockets

# optional VILLAS dependencies
RUN apt-get -y --no-install-recommends install \
   libmosquitto-dev \
	libconfig-dev \
   libnl-3-dev && rm -rf /var/lib/apt/lists/*;

# Install libiec61850 from source
RUN cd /tmp && \
	wget https://libiec61850.com/libiec61850/wp-content/uploads/2019/03/libiec61850-1.3.3.tar.gz && \
	tar -zxvf libiec61850-1.3.3.tar.gz && rm libiec61850-1.3.3.tar.gz && \
	cd libiec61850-1.3.3 && \
	mkdir build && cd build && \
	cmake -DBUILD_SHARED_LIBS=ON .. && make -j$(nproc) install && \
	rm -rf /tmp/libiec61850-1.3.3

# Python dependencies
ADD requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Install CIMpp from source
RUN cd /tmp && \
	git clone --recursive https://github.com/cim-iec/libcimpp.git && \
	mkdir -p libcimpp/build && cd libcimpp/build && \
	cmake -DCMAKE_INSTALL_LIBDIR=/usr/local/lib -DUSE_CIM_VERSION=CGMES_2.4.15_16FEB2016 -DBUILD_SHARED_LIBS=ON -DBUILD_ARABICA_EXAMPLES=OFF .. && make -j$(nproc) install && \
	rm -rf /tmp/libcimpp

# Install VILLAS from source
RUN cd /tmp && \
	git -c submodule.fpga.update=none clone --recursive https://git.rwth-aachen.de/acs/public/villas/node.git villasnode && \	
	mkdir -p villasnode/build && cd villasnode/build && \
	git -c submodule.fpga.update=none checkout a98ab9f1726476fdaa8966da63744794b691bf54 && git -c submodule.fpga.update=none submodule update --recursive && \
	cmake -DCMAKE_INSTALL_LIBDIR=/usr/local/lib .. && make install && \
	rm -rf /tmp/villasnode

# Remove this part in the future and use dedicated jupyter Dockerfile
# Activate Jupyter extensions
RUN apt-get -y --no-install-recommends install npm && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir jupyter jupyterlab jupyter_contrib_nbextensions nbconvert nbformat

EXPOSE 8888
