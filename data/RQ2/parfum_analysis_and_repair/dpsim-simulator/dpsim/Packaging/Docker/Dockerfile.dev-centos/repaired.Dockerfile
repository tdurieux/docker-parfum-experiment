FROM centos:8

LABEL \
	org.label-schema.schema-version = "1.0.0" \
	org.label-schema.name = "DPsim" \
	org.label-schema.license = "MPL 2.0" \
	org.label-schema.url = "http://dpsim.fein-aachen.org/" \
	org.label-schema.vcs-url = "https://github.com/sogno-platform/dpsim"

RUN cd /etc/yum.repos.d/ && sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && yum update -y

RUN dnf -y update && \
    dnf install -y epel-release dnf-plugins-core && \
    dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm && \
    dnf config-manager --set-enabled powertools && \
    dnf config-manager --set-enabled remi

# CUDA dependencies
RUN dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-rhel8.repo && \
    dnf --refresh -y install cuda-compiler-11-4 cuda-libraries-devel-11-4 cuda-nvprof-11-4 && \
    ln -s cuda-11.4 /usr/local/cuda

ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"

# Toolchain
RUN dnf -y install \
	git clang gdb ccache \
	redhat-rpm-config \
	rpmdevtools \
	make cmake ninja-build \
	doxygen \
	graphviz \
	pandoc \
	python3-pip \
	pkg-config \
    wget \
    libarchive \
    openblas-devel \
    gcc-gfortran

# Dependencies
RUN dnf --refresh -y install \
	python36-devel \
	eigen3-devel \
	libxml2-devel \
	graphviz-devel \
	gsl-devel

# VILLAS dependencies
RUN dnf -y install \
    openssl-devel \
    libuuid-devel \
    libconfig-devel \
    libnl3-devel \
    libcurl-devel \
    jansson-devel \
    mosquitto-devel \
    libjpeg-devel \
    zlib-devel

# CUDARPC and dependencies
RUN dnf install -y make bash git gcc autoconf libtool automake \
                   ncurses-devel zlib-devel binutils-devel mesa-libGL-devel \
                   libvdpau-devel mesa-libEGL-devel openssl-devel rpcbind \
                   rpcgen texinfo bison flex

ENV LD_LIBRARY_PATH="/usr/local/lib:/usr/local/lib64:${LD_LIBRARY_PATH}"
# copy gitlab-runner ssh credentials into build container
RUN git clone -b 2.0  --depth 1 --recurse-submodules https://git.rwth-aachen.de/acs/public/virtualization/cricket.git && \
    cd cricket && \
    make -j16 bin/cricket-client.so LOG=INFO && \
    make -j16 bin/cricket-server.so LOG=INFO && \
    make -j16 bin/libtirpc.so LOG=INFO && \
    make -j16 bin/libtirpc.so.3 LOG=INFO

ENV PATH="$PWD/cricket/bin:${PATH}"
ENV LD_LIBRARY_PATH="$PWD/cricket/bin:${LD_LIBRARY_PATH}"

# Install Libwebsockets from source because the repo variant is not suitable
RUN git clone --branch v4.0-stable --depth 1 https://libwebsockets.org/repo/libwebsockets && \
    mkdir -p libwebsockets/build && \
    pushd libwebsockets/build && \
    cmake -DLWS_WITH_IPV6=ON \
          -DLWS_WITHOUT_TESTAPPS=ON \
          -DLWS_WITHOUT_EXTENSIONS=OFF \
          -DLWS_WITH_SERVER_STATUS=ON \
          ${CMAKE_OPTS} .. && \
    make -j$(nproc) ${TARGET} && \
    popd


# Profiling dependencies
RUN dnf -y install \
    graphviz \
    libasan \
    cppcheck \
    gnuplot \
	qt5-qtbase \
    qt5-qtsvg
RUN pip3 install --no-cache-dir gprof2dot

# Install CIMpp from source
RUN cd /tmp && \
	git clone --recursive https://github.com/cim-iec/libcimpp.git && \
	mkdir -p libcimpp/build && cd libcimpp/build && \
	cmake -DCMAKE_INSTALL_LIBDIR=/usr/local/lib64 -DUSE_CIM_VERSION=CGMES_2.4.15_16FEB2016 -DBUILD_SHARED_LIBS=ON -DBUILD_ARABICA_EXAMPLES=OFF .. && make -j$(nproc) install && \
	rm -rf /tmp/libcimpp

# Install MAGMA from source
RUN cd /tmp && \
    wget https://icl.utk.edu/projectsfiles/magma/downloads/magma-2.6.0.tar.gz && \
    tar -xvzf magma-2.6.0.tar.gz && \
    mkdir -p magma-2.6.0/build && cd magma-2.6.0/build && \
    cmake .. -DMAGMA_ENABLE_CUDA=ON -DCMAKE_INSTALL_PREFIX=/ -DGPU_TARGET='Pascal Turing Ampere' -DBUILD_SHARED_LIBS=on && \
    make -j$(nproc) install && rm -rf /tmp/magma-2.6.0 && rm magma-2.6.0.tar.gz



# CIMpp and VILLAS are installed here
ENV LD_LIBRARY_PATH="/usr/local/lib64:${LD_LIBRARY_PATH}"

# Python dependencies
ADD requirements.txt .
RUN pip3 install --no-cache-dir -U setuptools
RUN pip3 install --no-cache-dir -U wheel
RUN pip3 install --no-cache-dir -r requirements.txt

# Remove this part in the future and use dedicated jupyter Dockerfile
# Activate Jupyter extensions
RUN dnf -y --refresh install npm
RUN pip3 install --no-cache-dir jupyter jupyter_contrib_nbextensions nbconvert nbformat

EXPOSE 8888
