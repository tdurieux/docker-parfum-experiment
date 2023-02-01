FROM ubuntu:21.10

USER root

ENV DEBIAN_FRONTEND=noninteractive

# Install some essentials
RUN apt-get update && apt-get install --no-install-recommends -y \
    libboost-all-dev && rm -rf /var/lib/apt/lists/*;

# Install python3
RUN apt-get install --no-install-recommends python3-dev python3-pip -y && rm -rf /var/lib/apt/lists/*;

# Install souffle dependencies
RUN apt-get install --no-install-recommends -y \
    bison \
    clang \
    cmake \
    doxygen \
    flex \
    g++ \
    git \
    libtinfo-dev \
    libffi-dev \
    libncurses5-dev \
    libsqlite3-dev \
    make \
    mcpp \
    python \
    sqlite \
    zlib1g-dev \
    libffi-dev \
    libffi7 \
    parallel \
 && rm -rf /var/lib/apt/lists/*

COPY ./docker/mac/souffle_2.2-1_arm64.deb /tmp/souffle.deb
RUN dpkg -i /tmp/souffle.deb
RUN apt-get install -f -y

# Dependencies for Gigahorse output viz
RUN apt-get update && apt-get install --no-install-recommends -y graphviz && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install pydot

# Set up a non-root 'gigahorse' user
RUN groupadd -r gigahorse && useradd -ms /bin/bash -g gigahorse gigahorse

RUN mkdir -p /opt/gigahorse/gigahorse-toolchain

# Copy gigahorse project root
COPY . /opt/gigahorse/gigahorse-toolchain/

RUN chown -R gigahorse:gigahorse /opt/gigahorse
RUN chmod -R o+rwx /opt/gigahorse

# Switch to new 'gigahorse' user context
USER gigahorse

# Souffle-addon bare-minimum make
RUN cd /opt/gigahorse/gigahorse-toolchain/souffle-addon && make libsoufflenum.so

CMD ["-h"]
ENTRYPOINT ["/opt/gigahorse/gigahorse-toolchain/gigahorse.py"]
