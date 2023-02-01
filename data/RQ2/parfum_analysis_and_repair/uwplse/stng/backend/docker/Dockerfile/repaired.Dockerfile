FROM shoaibkamil/sketch

RUN apt-get update
# install numpy because pip often fails to
RUN apt-get -y --no-install-recommends install python-pip python-numpy && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir asp pyparsing sympy

#RUN mkdir -p /z3
# RUN apt-get -y install software-properties-common
# RUN add-apt-repository ppa:git-core/ppa
# RUN apt-get update
# RUN apt-get -y install git
#ADD z3 /z3
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
WORKDIR /
RUN git clone https://github.com/Z3Prover/z3.git z3
WORKDIR /z3
# RUN git clone https://git01.codeplex.com/z3

#RUN  autoconf
#RUN  ./configure
RUN ls
RUN  python scripts/mk_make.py
WORKDIR  /z3/build
RUN  make -j4
RUN  make install

# update sketch-frontend and sketch-backend
#WORKDIR /sketch/sketch-backend
#RUN hg pull && hg update
WORKDIR /sketch
RUN rm -rf sketch-backend
RUN hg clone https://bitbucket.org/gatoatigrado/sketch-backend
WORKDIR /sketch/sketch-backend
RUN bash autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make clean
RUN make -j4

WORKDIR /sketch/sketch-frontend
RUN hg pull && hg update
RUN rm /usr/bin/sketch*
COPY sketch /usr/bin/sketch
RUN chmod a+x /usr/bin/sketch
RUN /usr/bin/sketch /sketch/sketch-frontend/src/test/sk/seq/miniTest1.sk

# set up Halide
RUN apt-get update
#RUN apt-get -y install llvm-3.4 llvm-3.4-dev clang-3.4 git zlib1g-dev
RUN apt-get -y --no-install-recommends install llvm-3.8 llvm-3.8-dev clang-3.8 git zlib1g-dev libedit-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /
ENV LLVM_CONFIG llvm-config-3.8
ENV CLANG clang-3.8
RUN git clone http://github.com/halide/Halide
WORKDIR /Halide
RUN make -j4

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add gfortran
RUN apt-get update
RUN apt-get -y --no-install-recommends install gfortran gdb && rm -rf /var/lib/apt/lists/*;

# upgrade six package
RUN pip install --no-cache-dir six --upgrade
