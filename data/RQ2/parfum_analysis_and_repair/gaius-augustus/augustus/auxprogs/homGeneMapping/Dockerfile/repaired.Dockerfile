FROM ubuntu:20.04

# Set timezone in tzdata
ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin"

# Install required packages
RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential wget git autoconf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# Install hal
RUN apt-get install --no-install-recommends -y libhdf5-dev && rm -rf /var/lib/apt/lists/*;
    # or alternatively install hdf5 from source:
    #WORKDIR /root
    #RUN wget http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.1/src/hdf5-1.10.1.tar.gz
    #RUN tar xzf hdf5-1.10.1.tar.gz
    #WORKDIR /root/hdf5-1.10.1
    #RUN ./configure --enable-cxx
    #RUN make && make install
    #ENV PATH="${PATH}:/root/hdf5-1.10.1/hdf5/bin"
RUN git clone https://github.com/benedictpaten/sonLib.git /opt/sonLib
WORKDIR /opt/sonLib
RUN make
RUN git clone https://github.com/ComparativeGenomicsToolkit/hal.git /opt/hal
WORKDIR /opt/hal
ENV RANLIB=ranlib
RUN make
ENV PATH="${PATH}:/opt/hal/bin"

# Install dependencies for homGeneMapping
RUN apt-get update
RUN apt-get install --no-install-recommends -y libgsl-dev liblpsolve55-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsqlite3-dev libmysql++-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-all-dev && rm -rf /var/lib/apt/lists/*;

# Clone AUGUSTUS repository
WORKDIR /root
RUN git clone https://github.com/Gaius-Augustus/Augustus.git
WORKDIR /root/Augustus

# Build load2sqlitedb
WORKDIR /root/Augustus/src/
RUN mkdir -p /root/Augustus/bin
RUN make load2sqlitedb
ENV PATH="${PATH}:/root/Augustus/bin"

# Build homGeneMapping
WORKDIR /root/Augustus/auxprogs/homGeneMapping/
RUN make

# Test homGeneMapping
RUN make test
