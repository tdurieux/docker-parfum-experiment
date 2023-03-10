# Copyright (c) 2020      Intel, Inc.  All rights reserved.
# Copyright (c) 2020      IBM Corporation.  All rights reserved.
#
# Base Build box for PRRTE
# Requires:
#  - Basic compile tooling and runtime support
#  - libevent - retrieve v2.1.11-stable from web
#  - hwloc - retrieve v2.2.0 from web
#  - curl
#  - libjansson - retrieve v2.13.1 from web
#  - PMIx - cloned from 'master' branch
#  - PRRTE - cloned from 'master' branch
#
#
FROM opensuse/leap

MAINTAINER Ralph Castain <ralph.h.castain@intel.com>

# ------------------------------------------------------------
# Install required packages
# ------------------------------------------------------------
RUN zypper --non-interactive refresh && \
    zypper --non-interactive update && \
    zypper --non-interactive install \
    openssh \
    gcc gdb strace \
    binutils less wget which sudo \
    perl numactl gzip \
    autoconf automake libtool flex bison \
    iproute net-tools make git pandoc \
    atk cairo tcl tcsh tk pciutils lsof ethtool bc file \
    valgrind curl curl-devel && \
    zypper --non-interactive clean

# ------------------------------------------------------------
# Define support libraries
# - hwloc
# - libevent
# - libjansson
# ------------------------------------------------------------
RUN mkdir -p /opt/hpc/local/build
RUN mkdir -p /opt/hpc/rndvz

ARG LIBEVENT_INSTALL_PATH=/opt/hpc/local/libevent
ENV LIBEVENT_INSTALL_PATH=$LIBEVENT_INSTALL_PATH
ARG HWLOC_INSTALL_PATH=/opt/hpc/local/hwloc
ENV HWLOC_INSTALL_PATH=$HWLOC_INSTALL_PATH
ARG LIBJANSSON_INSTALL_PATH=/opt/hpc/local/libjansson
ENV LIBJANSSON_INSTALL_PATH=$LIBJANSSON_INSTALL_PATH

RUN cd /opt/hpc/local/build && \
    wget https://github.com/libevent/libevent/releases/download/release-2.1.11-stable/libevent-2.1.11-stable.tar.gz && \
    ls && \
    tar xf libevent-2.1.11-stable.tar.gz && \
    cd libevent-2.1.11-stable && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=${LIBEVENT_INSTALL_PATH} > /dev/null && \
    make > /dev/null && \
    make install > /dev/null && rm libevent-2.1.11-stable.tar.gz
RUN cd /opt/hpc/local/build && \
    wget https://download.open-mpi.org/release/hwloc/v2.2/hwloc-2.2.0.tar.gz && \
    tar xf hwloc-2.2.0.tar.gz && \
    cd hwloc-2.2.0 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=${HWLOC_INSTALL_PATH} > /dev/null && \
    make > /dev/null && \
    make install > /dev/null && \
    cd .. && \
    rm -rf /opt/hpc/local/build/* && rm hwloc-2.2.0.tar.gz
RUN cd /opt/hpc/local/build && \
    wget https://digip.org/jansson/releases/jansson-2.13.1.tar.gz && \
    tar xf jansson-2.13.1.tar.gz && \
    cd jansson-2.13.1 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=${LIBJANSSON_INSTALL_PATH} > /dev/null && \
    make > /dev/null && \
    make install > /dev/null && \
    cd .. && \
    rm -rf /opt/hpc/local/build/* && rm jansson-2.13.1.tar.gz

ENV LD_LIBRARY_PATH="$HWLOC_INSTALL_PATH/bin:$LIBEVENT_INSTALL_PATH/lib:$LIBJANSSON_INSTALL_PATH/lib:${LD_LIBRARY_PATH}"


# -----------------------------
# ------------------------------------------------------------
# PMIx Install
# ------------------------------------------------------------
ENV PMIX_ROOT=/opt/hpc/local/pmix
ENV LD_LIBRARY_PATH="$PMIX_ROOT/lib:${LD_LIBRARY_PATH}"

RUN cd /opt/hpc/local/build && \
    git clone -q -b master https://github.com/openpmix/openpmix.git && \
    cd openpmix && \
    ./autogen.pl > /dev/null && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=${PMIX_ROOT} \
                --with-hwloc=${HWLOC_INSTALL_PATH} \
                --with-libevent=${LIBEVENT_INSTALL_PATH} \
                --with-curl \
                --with-jansson=${LIBJANSSON_INSTALL_PATH} > /dev/null && \
    make -j 10 > /dev/null && \
    make -j 10 install > /dev/null && \
    cd .. && rm -rf /opt/hpc/local/build/*

# ------------------------------------------------------------
# PRRTE Install
# ------------------------------------------------------------
ENV PRRTE_ROOT=/opt/hpc/local/prrte
ENV PATH="$PRRTE_ROOT/bin:${PATH}"
ENV LD_LIBRARY_PATH="$PRRTE_ROOT/lib:${LD_LIBRARY_PATH}"

RUN cd /opt/hpc/local/build && \
    git clone -q -b master https://github.com/openpmix/prrte.git && \
    cd prrte && \
    ./autogen.pl > /dev/null && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=${PRRTE_ROOT} \
                --with-hwloc=${HWLOC_INSTALL_PATH} \
                --with-libevent=${LIBEVENT_INSTALL_PATH} \
                --with-pmix=${PMIX_ROOT} > /dev/null && \
    make -j 10 > /dev/null && \
    make -j 10 install > /dev/null && \
    rm -rf /opt/hpc/local/build/*

# ------------------------------------------------------------
# Fixup the ssh login
# ------------------------------------------------------------
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N "" && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key  -N "" && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key  -N "" && \
    echo "        LogLevel ERROR" >> /etc/ssh/ssh_config && \
    echo "        StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "        UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config

# ------------------------------------------------------------
# Adjust default ulimit for core files
# ------------------------------------------------------------
RUN echo '*               hard    core            -1' >> /etc/security/limits.conf && \
    echo '*               soft    core            -1' >> /etc/security/limits.conf && \
    echo 'ulimit -c unlimited' >> /root/.bashrc

# ------------------------------------------------------------
# Create a user account
# ------------------------------------------------------------
RUN groupadd -r prteuser && useradd -r -m -b /home -g prteuser prteuser
USER prteuser
RUN  cd /home/prteuser && \
        ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa && chmod og+rX . && \
        cd .ssh && cat id_rsa.pub > authorized_keys && chmod 644 authorized_keys && \
        exit

# ------------------------------------------------------------
# Give the user passwordless sudo powers
# ------------------------------------------------------------
USER root
RUN echo "prteuser    ALL = NOPASSWD: ALL" >> /etc/sudoers

# ------------------------------------------------------------
# Adjust the default environment
# ------------------------------------------------------------
USER root

ENV PRRTE_MCA_prrte_default_hostfile=/opt/hpc/etc/hostfile.txt
ENV PATH=$PATH:/opt/hpc/local/hwloc/bin
# Need to do this so that the 'prteuser' can have them too, not just root
RUN echo "export PMIX_ROOT=/opt/hpc/install/pmix" >> /etc/bashrc && \
    echo "export PRRTE_ROOT=/opt/hpc/install/prrte" >> /etc/bashrc  && \
    echo "export PATH=\$PRRTE_ROOT/bin:\$PATH" >> /etc/bashrc  && \
    echo "export LD_LIBRARY_PATH=\$PMIX_ROOT/lib:\$LD_LIBRARY_PATH" >> /etc/bashrc && \
    echo "export LD_LIBRARY_PATH=$HWLOC_INSTALL_PATH/lib:$LIBEVENT_INSTALL_PATH/lib:\$LD_LIBRARY_PATH" >> /etc/bashrc && \
    echo "export LD_LIBRARY_PATH=\$LIBJANSSON_INSTALL_PATH/lib:\$LD_LIBRARY_PATH" >> /etc/bashrc && \
    echo "export LD_LIBRARY_PATH=\$PRRTE_ROOT/lib:\$LD_LIBRARY_PATH" >> /etc/bashrc && \
    echo "export PRRTE_MCA_prrte_default_hostfile=$PRRTE_MCA_prrte_default_hostfile" >> /etc/bashrc && \
    echo "ulimit -c unlimited" >> /etc/bashrc && \
    echo "alias pd=pushd" >> /etc/bashrc

# ------------------------------------------------------------
# Kick off the ssh daemon
# ------------------------------------------------------------
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

# ------------------------------------------------------------
# Tickle ptrace scope for Mac stacktrace
# ------------------------------------------------------------
CMD ["echo", "0", ">", "/proc/sys/kernel/yama/ptrace_scope"]

# ------------------------------------------------------------
# Kick off the PRRTE daemon
# ------------------------------------------------------------
USER prteuser

CMD ["prte"]

