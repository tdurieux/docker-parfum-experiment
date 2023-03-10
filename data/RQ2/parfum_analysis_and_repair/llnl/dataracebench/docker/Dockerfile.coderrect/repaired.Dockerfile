# pull base image

FROM ubuntu:18.04

# Install packages.
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        bc \
        build-essential \
        clang-9 \
        gfortran \
        git \
        libomp-dev \
        python3 \
        time \
        wget && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/*

# Setup environment.
RUN ln -s $(which clang-9) /usr/bin/clang
RUN ln -s $(which clang++-9) /usr/bin/clang++

# Install Coderrect Scanner
RUN wget -q https://public-installer-pkg.s3.us-east-2.amazonaws.com/coderrect-linux-0.8.0.tar.gz
RUN tar -xf coderrect-linux-0.8.0.tar.gz && rm coderrect-linux-0.8.0.tar.gz
ENV PATH="${PATH}:/coderrect-linux-0.8.0/bin"

# Get DataRaceBench
RUN git clone https://github.com/LLNL/dataracebench.git
