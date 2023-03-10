FROM ubuntu:bionic as builder

# var
ENV VIRT_ENV ilang-env
ENV BUILD_ROOT /ibuild
ENV BUILD_PREF $BUILD_ROOT/$VIRT_ENV

# root dir
WORKDIR $BUILD_ROOT

# build packages
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install --yes --no-install-recommends \
    bison \
    build-essential \
    cmake \
    curl \
    expect \
    flex \
    gawk \
    git \
    graphviz \
    libboost-all-dev \
    libgmp-dev \
    libreadline-dev \
    libffi-dev \
    libmpfr-dev \
    libmpc-dev \
    pkg-config \
    python3 \
    python3-pip \
    tcl-dev \
    vim \
    wget \
    xdot=0.9-1 \
    && rm -rf /var/lib/apt/lists/*

# portable build result
WORKDIR $BUILD_ROOT
RUN pip3 install --no-cache-dir virtualenv
RUN virtualenv $VIRT_ENV

# z3
ENV Z3_DIR $BUILD_ROOT/z3
WORKDIR $BUILD_ROOT
ADD https://api.github.com/repos/Z3Prover/z3/git/refs/heads/master z3_version.json
RUN git clone https://github.com/Z3Prover/z3.git $Z3_DIR
WORKDIR $Z3_DIR
RUN python scripts/mk_make.py --prefix $BUILD_PREF
WORKDIR $Z3_DIR/build
RUN make -j"$(nproc)" && \
    make install

# Yosys
ENV YOSYS_DIR $BUILD_ROOT/yosys
WORKDIR $BUILD_ROOT
ADD https://api.github.com/repos/cliffordwolf/yosys/git/refs/heads/master yosys_version.json
RUN git clone https://github.com/YosysHQ/yosys.git $YOSYS_DIR
WORKDIR $YOSYS_DIR
RUN make config-gcc && \
    make -j"$(nproc)" && \
    PREFIX=$BUILD_PREF make install

# CoSA
ENV COSA_DIR $BUILD_ROOT/CoSA
WORKDIR $BUILD_ROOT
ADD https://api.github.com/repos/cristian-mattarei/CoSA/git/refs/heads/master cosa_version.json
RUN git clone https://github.com/cristian-mattarei/CoSA.git $COSA_DIR
WORKDIR $COSA_DIR
RUN $BUILD_PREF/bin/pip3 install --no-cache-dir -e .

# PySMT - Boolector
WORKDIR $BUILD_ROOT
RUN wget https://raw.githubusercontent.com/Bo-Yuan-Huang/pysmt/master/pysmt/cmd/installers/btor.py
RUN mv btor.py $BUILD_PREF/lib/python3.6/site-packages/pysmt/cmd/installers/btor.py
RUN wget https://raw.githubusercontent.com/Bo-Yuan-Huang/pysmt/master/pysmt/solvers/btor.py
RUN mv btor.py $BUILD_PREF/lib/python3.6/site-packages/pysmt/solvers/btor.py
RUN $BUILD_PREF/bin/pip3 install --no-cache-dir cython

#
# Deployment
#
FROM ubuntu:bionic

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install --yes --no-install-recommends \
    bison \
    build-essential \
    cmake \
    curl \
    flex \
    git \
    libboost-all-dev \
    libgmp-dev \
    libgomp1 \
    libmpfr-dev \
    libmpc-dev \
    pkg-config \
    python3 \
    python3-pip \
    tcl-dev \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

ENV VIRT_ENV ilang-env
ENV BUILD_ROOT /ibuild
ENV BUILD_PREF $BUILD_ROOT/$VIRT_ENV

WORKDIR /root/workspace

RUN echo "source $BUILD_PREF/bin/activate" >> init.sh
RUN echo "export PYTHONPATH=$BUILD_PREF/lib:\$PYTHONPATH" >> init.sh
RUN echo "export LD_LIBRARY_PATH=$BUILD_PREF/lib:\$LD_LIBRARY_PATH" >> init.sh
RUN echo "export CMAKE_PREFIX_PATH=$BUILD_PREF:\$CMAKE_PREFIX_PATH" >> init.sh
RUN echo "cd $(pwd)" >> init.sh

# configure files
COPY --from=builder $BUILD_PREF $BUILD_PREF
COPY --from=builder $BUILD_ROOT/CoSA/ $BUILD_ROOT/CoSA/

CMD echo "run 'source init.sh' to start" && /bin/bash
