FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install openssh-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install automake autotools-dev g++ git libcurl4-gnutls-dev libfuse-dev libssl-dev libxml2-dev make pkg-config && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git && \
    cd s3fs-fuse && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install

RUN mkdir -p /var/run/sshd

COPY entrypoint /
RUN chmod +x /entrypoint

# SSH username and password
ENV SFTP_USER=sftp
ENV SFTP_PASSWORD=changeme1

EXPOSE 22

ENTRYPOINT ["/entrypoint"]