FROM centos:8

ARG CONFD_VERSION

ENV CONFD_VERSION=${CONFD_VERSION}
ENV CONFD_DIR=/confd
ENV USE_SSL_DIR=/usr/lib64
ENV LD_LIBRARY_PATH=${USE_SSL_DIR}:${CONFD_DIR}/lib:$LD_LIBRARY_PATH
ENV PATH=${CONFD_DIR}/bin:${NCS_DIR}/bin:${USE_SSL_DIR}/bin:/home/${USER}:$PATH
ENV CONFD=${CONFD_DIR}/bin/confd

WORKDIR /
RUN dnf group install -y "Development Tools" \
    && dnf install -y openssh openssl-devel compat-openssl10 python3 python3-pip nano \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install --no-cache-dir paramiko

COPY confd-${CONFD_VERSION}.linux.x86_64.installer.bin /tmp
WORKDIR ${CONFD_DIR}
RUN ln -s /usr/lib64/libcrypto.so.10 /usr/lib64/libcrypto.so.1.0.0 \
    && /tmp/confd-${CONFD_VERSION}.linux.x86_64.installer.bin ${CONFD_DIR} \
    && rm -rf examples.confd doc \
    && yes | ssh-keygen -m pem -N '' -f ${CONFD_DIR}/etc/confd/ssh/ssh_host_rsa_key

ADD app.tar.gz /
WORKDIR /app

CMD [ "./run.sh" ]