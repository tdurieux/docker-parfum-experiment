FROM ubuntu:bionic

RUN useradd -m retdec
WORKDIR /home/retdec
ENV HOME /home/retdec

RUN apt-get -y update && \
	DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
	build-essential \
	cmake \
	git \
	perl \
	python3 \
	doxygen \
	graphviz \
	upx \
	flex \
	bison \
	zlib1g-dev \
	libtinfo-dev \
	autoconf \
	automake \
	pkg-config \
	m4 \
	libtool && rm -rf /var/lib/apt/lists/*;

# New versions of docker (>v17.09.0-ce) support the --chown flag given to COPY.
# Once this version is more wide spread, consider updating this repository's
# Dockerfiles to use the new directive.
COPY . retdec
RUN chown -R retdec:retdec retdec

USER retdec
RUN cd retdec && \
	mkdir build && \
	cd build && \
	cmake .. -DCMAKE_INSTALL_PREFIX=/home/retdec/retdec-install && \
	make -j$(nproc) && \
	make install

ENV PATH /home/retdec/retdec-install/bin:$PATH
