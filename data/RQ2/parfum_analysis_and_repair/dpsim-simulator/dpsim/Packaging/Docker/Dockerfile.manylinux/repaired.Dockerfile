# This Dockerfile is used to build Python wheels for uploading
# binary releases of DPsim to PyPi.org
#
# See: https://github.com/pypa/manylinux

FROM quay.io/pypa/manylinux2010_x86_64

ENV VILLAS_VERSION=0.8.0
ENV PLAT=manylinux2010_x86_64

LABEL \
	org.label-schema.schema-version = "1.0" \
	org.label-schema.name = "DPsim" \
	org.label-schema.license = "MPL 2.0" \
	org.label-schema.vendor = "Institute for Automation of Complex Power Systems, RWTH Aachen University" \
	org.label-schema.author.name = "Steffen Vogel" \
	org.label-schema.author.email = "stvogel@eonerc.rwth-aachen.de" \
	org.label-schema.url = "http://fein-aachen.org/projects/dpsim/" \
	org.label-schema.vcs-url = "https://git.rwth-aachen.de/acs/core/simulation/DPsim"

# Set up DPsim dependencies
ADD https://packages.fein-aachen.org/redhat/fein.repo /etc/yum.repos.d/

# Enable Extra Packages for Enterprise Linux (EPEL) repo
RUN yum -y install epel-release && rm -rf /var/cache/yum

# Uninstall old CMake v2.8
RUN yum -y remove cmake

# Toolchain
RUN yum -y install \
	devtoolset-7-toolchain \
	pkgconfig make cmake3 flex \
	git tar \
	expat-devel \
	gsl-devel \
    libxml2-devel \
	libpng-devel \
	freetype-devel && rm -rf /var/cache/yum
	# libvillas-devel-${VILLAS_VERSION} \
	# villas-node-${VILLAS_VERSION}

RUN update-alternatives --install /usr/bin/cmake cmake /usr/bin/cmake3 1

RUN git clone https://gitlab.com/graphviz/graphviz.git && \
	mkdir -p graphviz/build && cd graphviz/build && \
	cmake .. && make install -j$(nproc)

RUN git clone --branch v3.1.1 https://github.com/LLNL/sundials.git && \
    mkdir -p sundials/build && \
    cd  sundials/build && \
    cmake .. \
        -DBUILD_SHARED_LIBS=OFF \
        -DBUILD_STATIC_LIBS=ON \
        -DEXAMPLES_ENABLE_C=OFF \
        -DCMAKE_C_FLAGS=-fPIC \
        -DCMAKE_CXX_FLAGS=-fPIC && \
	make -j$(nproc) install
