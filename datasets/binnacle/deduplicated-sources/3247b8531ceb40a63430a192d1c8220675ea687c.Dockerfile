FROM quay.io/pypa/manylinux1_x86_64
RUN yum -y install devtoolset-2-libstdc++-devel devtoolset-2-binutils-devel devtoolset-2-libatomic-devel gcc libffi-devel

ENV PIP_NO_CACHE_DIR off
ENV PIP_DISABLE_PIP_VERSION_CHECK on
ENV PYTHONUNBUFFERED 1

RUN set -ex \
	&& version=3.4.3 \
	&& checksum=66b8d315c852908be9f79e1a18b8778714659fce4ddb2d041af8680a239202fc \
	&& wget --no-check-certificate "https://cmake.org/files/v3.4/cmake-$version-Linux-x86_64.tar.gz" \
	&& echo "$checksum  cmake-$version-Linux-x86_64.tar.gz" | sha256sum -c - \
	&& tar -xzf "cmake-$version-Linux-x86_64.tar.gz" --strip-components=1 -C /usr/local \
	&& rm "cmake-$version-Linux-x86_64.tar.gz"
RUN curl https://static.rust-lang.org/rustup.sh | sh -s -- --prefix=/usr/local --disable-sudo

ENV SYMSYND_MANYLINUX 1
ENV PATH "/opt/python/cp27-cp27mu/bin:$PATH"
RUN mkdir -p /usr/src/symsynd
WORKDIR /usr/src/symsynd
COPY . /usr/src/symsynd

ENTRYPOINT [ "make", "MANYLINUX=1" ]
