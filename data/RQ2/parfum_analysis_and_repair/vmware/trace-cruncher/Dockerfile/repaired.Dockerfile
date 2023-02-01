# SPDX-License-Identifier: LGPL-2.1
# Copyright (C) 2022, VMware Inc, June Knauth <june.knauth@gmail.com>

FROM debian:bullseye
# Install APT and pip dependencies
RUN apt update && apt install --no-install-recommends build-essential git cmake libjson-c-dev libpython3-dev cython3 python3-numpy python3-pip flex valgrind binutils-dev pkg-config swig curl -y && pip3 install --no-cache-dir pkgconfig GitPython && rm -rf /var/lib/apt/lists/*;
# Download the latest git-snapshot tool from the trace-cruncher GitHub
# Then use it to download a snapshot of trace-cruncher and its dependencies (defined in repos)
RUN mkdir build
WORKDIR build
RUN curl -f -o git-snapshot.sh https://raw.githubusercontent.com/vmware/trace-cruncher/tracecruncher/scripts/git-snapshot/git-snapshot.sh && \
 curl -f -o repos https://raw.githubusercontent.com/vmware/trace-cruncher/tracecruncher/scripts/git-snapshot/repos && \
bash ./git-snapshot.sh -l -i "trace-cruncher;https://github.com/vmware/trace-cruncher.git;tracecruncher;" && \
bash ./git-snapshot.sh -f repos
# Build kernel tracing libs
RUN cd libtraceevent && make && make install
RUN cd libtracefs && make && make install
RUN cd trace-cmd && make && make install_libs
RUN cd kernel-shark/build && cmake .. && make && make install
# Install trace-cruncher
RUN cd trace-cruncher && make && make install
# Remove build dependencies; run build with --squash to reduce image size
RUN cd trace-cruncher && make clean
RUN pip3 uninstall pkgconfig -y && apt remove build-essential cmake python3-pip libpython3-dev flex valgrind binutils-dev pkg-config swig curl -y && apt autoremove -y
