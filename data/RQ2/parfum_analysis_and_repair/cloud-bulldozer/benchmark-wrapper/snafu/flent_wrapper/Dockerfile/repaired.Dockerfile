FROM registry.access.redhat.com/ubi8:latest as builder

RUN dnf -y install git wget gcc gcc-c++ make bzip2 --nodocs

RUN mkdir /tmp/install

# Build netperf
WORKDIR /root
RUN wget https://github.com/HewlettPackard/netperf/archive/netperf-2.7.0.tar.gz && tar -xzf netperf-2.7.0.tar.gz && rm netperf-2.7.0.tar.gz
WORKDIR /root/netperf-netperf-2.7.0
RUN sed -i 's/inline void demo_interval_display(double actual_interval)/void demo_interval_display(double actual_interval)/g' src/netlib.c && sed -i 's/inline void demo_interval_tick(uint32_t units)/void demo_interval_tick(uint32_t units)/g' src/netlib.c
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-demo --prefix=/tmp/install && make && make install

# Build iperf2
WORKDIR /root
RUN git clone -n https://git.code.sf.net/p/iperf2/code iperf2-code
# A specific commit must be specified because the following one introduced a breaking change for flent
RUN cd iperf2-code && git checkout bf687b4aac023b303cea08bd1a7248d62ad70f47 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/tmp/install && make && make install

# The main container
FROM registry.access.redhat.com/ubi8:latest

COPY /snafu/image_resources/centos8-appstream.repo /etc/yum.repos.d/centos8-appstream.repo
RUN dnf install -y --nodocs git python3-pip python3-devel iputils redis gcc --enablerepo=centos8-appstream && dnf clean all

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir flent

RUN ln -s /usr/bin/python3 /usr/bin/python

# Install built libs
COPY --from=builder /tmp/install/bin/* /bin/

# Add snafu
RUN mkdir -p /opt/snafu/
COPY . /opt/snafu/
RUN pip3 install --no-cache-dir -e /opt/snafu/
