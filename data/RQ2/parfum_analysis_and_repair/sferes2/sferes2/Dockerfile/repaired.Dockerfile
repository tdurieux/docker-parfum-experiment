FROM ubuntu:16.04
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y libboost-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-test-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-filesystem-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-program-options-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-graph-parallel-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-thread-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-regex-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libeigen3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-simplejson && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-mpi-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openmpi-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openmpi-bin && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgoogle-perftools-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libtbb-dev && rm -rf /var/lib/apt/lists/*;
ENV LD_LIBRARY_PATH /usr/libx86_64-linux-gnu
RUN mkdir /git && cd /git && git clone https://github.com/sferes2/sferes2.git && cd sferes2 && ./waf configure && ./waf build

