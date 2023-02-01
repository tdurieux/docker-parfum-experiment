FROM ubuntu

# Install prerequisities
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y -q libboost-all-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libgmp3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libreadline-dev && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install gfortran && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends cmake -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# Install Blas
WORKDIR /myappdir
RUN wget https://github.com/xianyi/OpenBLAS/releases/download/v0.3.17/OpenBLAS-0.3.17.tar.gz
RUN tar zxvf OpenBLAS-0.3.17.tar.gz && rm OpenBLAS-0.3.17.tar.gz
RUN rm OpenBLAS-0.3.17.tar.gz
WORKDIR /myappdir/OpenBLAS-0.3.17
RUN make
RUN make install PREFIX=/blasdir
RUN apt install --no-install-recommends pkg-config -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends libgsl-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y bliss && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y cliquer && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y liblapack3 libopenblas0 libtbb2 && rm -rf /var/lib/apt/lists/*;

# Install scipoptsuite from source (make sure that it is downloaded first)
WORKDIR /myappdir
COPY scipoptsuite-8.0.0.tgz .
RUN tar xvf scipoptsuite-8.0.0.tgz && rm scipoptsuite-8.0.0.tgz
RUN rm scipoptsuite-8.0.0.tgz
WORKDIR /myappdir/scipoptsuite-8.0.0
RUN make
RUN make install INSTALLDIR="/myappdir/local/src/scipoptsuite-8.0.0/scip"

# Install Gobnilp
RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
WORKDIR /myappdir
RUN git clone https://bitbucket.org/jamescussens/gobnilp.git
WORKDIR /myappdir/gobnilp/
RUN git checkout 4347c64
RUN ./configure.sh /myappdir/scipoptsuite-8.0.0/scip/ /blasdir
RUN make