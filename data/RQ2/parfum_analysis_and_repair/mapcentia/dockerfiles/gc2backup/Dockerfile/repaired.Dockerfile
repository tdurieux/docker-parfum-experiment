FROM debian:bullseye-slim
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install wget gnupg && rm -rf /var/lib/apt/lists/*;
RUN echo "deb https://apt.postgresql.org/pub/repos/apt bullseye-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# Install packages
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install postgresql-client-14 build-essential git libfuse-dev libcurl4-openssl-dev libxml2-dev mime-support automake libtool pkg-config libssl-dev fuse rsync && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/s3fs-fuse/s3fs-fuse &&\
    cd s3fs-fuse/ &&\
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --with-openssl && \
    make && \
    make install

COPY postgresqlbackup.sh /postgresqlbackup.sh
RUN chmod +x /postgresqlbackup.sh
ENTRYPOINT ["/postgresqlbackup.sh"]