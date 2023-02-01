FROM sameersbn/gitlab:8.4.4

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y build-essential libfuse-dev libcurl4-openssl-dev libxml2-dev automake libtool && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.79.tar.gz | tar zxv -C /usr/src
RUN cd /usr/src/s3fs-fuse-1.79 && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && make && make install && cd / && rm -rf /usr/src/s3fs-fuse-1.79
RUN mkdir -p /home/git/s3fs

VOLUME /etc/supervisor/conf.d/s3fs.conf