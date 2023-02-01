FROM centos:7
# this is joshua-agent

WORKDIR /tmp

RUN yum repolist && \
    yum install -y \
        centos-release-scl-rh \
        epel-release \
        scl-utils \
        yum-utils && \
    yum -y install \
        bzip2 \
        devtoolset-8 \
        devtoolset-8-libasan-devel \
        devtoolset-8-liblsan-devel \
        devtoolset-8-libtsan-devel \
        devtoolset-8-libubsan-devel \
        gettext \
        golang \
        java-11-openjdk-devel \
        mono-core \
        net-tools \
        rh-python38 \
        rh-python38-python-devel \
        rh-python38-python-pip \
        rh-ruby27 \
        rh-ruby27-ruby-devel \
        libatomic && \
    source /opt/rh/devtoolset-8/enable && \
    source /opt/rh/rh-python38/enable && \
    source /opt/rh/rh-ruby27/enable && \
    pip3 install --no-cache-dir \
        python-dateutil \
        subprocess32 \
        psutil && \
    gem install ffi --platform=ruby && \
    groupadd -r joshua -g 4060 && \
    useradd \
        -rm \
        -d /home/joshua \
        -s /bin/bash \
        -u 4060 \
        -g joshua \
        joshua && \
    mkdir -p /var/joshua && \
    chown -R joshua:joshua /var/joshua && \
    rm -rf /tmp/* && rm -rf /var/cache/yum

# valgrind
RUN source /opt/rh/devtoolset-8/enable && \
    curl -f -Ls https://sourceware.org/pub/valgrind/valgrind-3.17.0.tar.bz2 -o valgrind-3.17.0.tar.bz2 && \
    echo "ad3aec668e813e40f238995f60796d9590eee64a16dff88421430630e69285a2  valgrind-3.17.0.tar.bz2" > valgrind-sha.txt && \
    sha256sum -c valgrind-sha.txt && \
    mkdir valgrind && \
    tar --strip-components 1 --no-same-owner --no-same-permissions --directory valgrind -xjf valgrind-3.17.0.tar.bz2 && \
    cd valgrind && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install && \
    cd .. && \
    rm -rf /tmp/* && rm valgrind-3.17.0.tar.bz2

COPY childsubreaper/ /opt/joshua/install/childsubreaper
COPY joshua/ /opt/joshua/install/joshua
COPY setup.py /opt/joshua/install/

RUN source /opt/rh/devtoolset-8/enable && \
    source /opt/rh/rh-python38/enable && \
    source /opt/rh/rh-ruby27/enable && \
    pip3 install --no-cache-dir /opt/joshua/install && \
    rm -rf /opt/joshua/install

ARG OLD_FDB_BINARY_DIR=/app/deploy/global_data/oldBinaries/
ARG OLD_TLS_LIBRARY_DIR=/app/deploy/runtime/.tls_5_1/
ARG FDB_VERSION="6.3.18"
RUN if [ "$(uname -p)" == "x86_64" ]; then \
        mkdir -p ${OLD_FDB_BINARY_DIR} \
                 ${OLD_TLS_LIBRARY_DIR} \
                 /usr/lib/foundationdb/plugins && \
        for old_fdb_server_version in 6.3.186.3.176.3.166.3.156.3.136.3.126.3.96.2.306.2.296.2.286.2.276.2.266.2.256.2.246.2.236.2.226.2.216.2.206.2.196.2.186.2.176.2.166.2.156.2.106.1.136.1.126.1.116.1.106.0.186.0.176.0.166.0.156.0.145.2.85.2.75.1.75.1.6; do \
        
            curl -f -Ls https://github.com/apple/foundationdb/releases/download/${old_fdb_server_version}/fdbserver.x86_64 -o ${OLD_FDB_BINARY_DIR}/fdbserver-${old_fdb_server_version}; \
           done \
        && \
        chmod +x ${OLD_FDB_BINARY_DIR}/* && \
        curl -f -Ls https://fdb-joshua.s3.amazonaws.com/old_tls_library.tgz | tar -xz -C ${OLD_TLS_LIBRARY_DIR} --strip-components=1 && \
        curl -f -Ls https://github.com/apple/foundationdb/releases/download/${FDB_VERSION}/libfdb_c.x86_64.so -o /usr/lib64/libfdb_c_${FDB_VERSION}.so && \
        ln -s /usr/lib64/libfdb_c_${FDB_VERSION}.so /usr/lib64/libfdb_c.so && \
        ln -s ${OLD_TLS_LIBRARY_DIR}/FDBGnuTLS.so /usr/lib/foundationdb/plugins/fdb-libressl-plugin.so && \
        ln -s ${OLD_TLS_LIBRARY_DIR}/FDBGnuTLS.so /usr/lib/foundationdb/plugins/FDBGnuTLS.so; \
    fi

ENV FDB_CLUSTER_FILE=/etc/foundationdb/fdb.cluster
ENV AGENT_TIMEOUT=300

USER joshua
CMD source /opt/rh/devtoolset-8/enable && \
    source /opt/rh/rh-python38/enable && \
    source /opt/rh/rh-ruby27/enable && \
    python3 -m joshua.joshua_agent \
        -C ${FDB_CLUSTER_FILE} \
        --work_dir /var/joshua \
        --agent-idle-timeout ${AGENT_TIMEOUT}

