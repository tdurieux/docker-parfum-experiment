FROM        ubuntu:xenial
MAINTAINER  Robin Sommer <robin@icir.org>

RUN echo "deb http://apt.llvm.org/xenial     llvm-toolchain-xenial-3.9 main" >>/etc/apt/sources.list
RUN echo "deb-src http://apt.llvm.org/xenial llvm-toolchain-xenial-3.9 main" >>/etc/apt/sources.list

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install cmake git build-essential vim python curl ninja-build && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install bison flex libpapi-dev libgoogle-perftools-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libpcap-dev libssl-dev python-dev swig zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gdb && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install btest bsdmainutils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends --allow-unauthenticated install clang-3.9 llvm-3.9 lldb-3.9 && rm -rf /var/lib/apt/lists/*;

# Additional tools to build the docs
RUN apt-get -y --no-install-recommends install doxygen python-sphinx python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir sphinx-better-theme

RUN cd /usr/bin && for i in $(ls *-3.9); do ln -s $i $(echo $i | sed 's/-3.9//g'); done

ENV PATH $PATH:/usr/local/bro/bin:/opt/bro/aux/btest
ENV PATH $PATH:/opt/hilti/tools:/opt/hilti/build/tools:/opt/hilti/build/tools/spicy-driver:/opt/hilti/build/tools/spicy-dump
ENV BRO_PLUGIN_PATH /opt/hilti/build/bro

# Default to run upon container startup.
CMD hilti-config --version; spicy-config --version; bash

# Put a couple small examples in place.
WORKDIR /root
ADD docker/ .

# Set up Bro
RUN mkdir -p /opt/bro/src
RUN cd /opt/bro && git clone -b release/2.5 --recursive git://git.bro.org/bro src
RUN cd /opt/bro/src && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --generator=Ninja && cd build && ninja && ninja install && cd ..

# Set up HILTI.
ADD . /opt/hilti
RUN cd /opt/hilti && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --bro-dist=/opt/bro/src --generator=Ninja && cd build && ninja
