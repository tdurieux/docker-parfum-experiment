FROM centos:7

ARG CC=gcc

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && rm -rf /var/cache/yum
RUN yum install -y \
	findutils \
	gcc \
	git \
	gnutls-devel \
	iproute \
	iptables \
	libaio-devel \
	libasan \
	libcap-devel \
	libnet-devel \
	libnl3-devel \
	make \
	procps-ng \
	protobuf-c-devel \
	protobuf-devel \
	protobuf-python \
	python \
	python-flake8 \
	python-ipaddress \
	python2-future \
	python2-junit_xml \
	python-yaml \
	python-six \
	sudo \
	tar \
	which \
	e2fsprogs \
	python2-pip \
	rubygem-asciidoctor && rm -rf /var/cache/yum

COPY . /criu
WORKDIR /criu

RUN make mrproper && date && make -j $(nproc) CC="$CC" && date

# The rpc test cases are running as user #1000, let's add the user
RUN adduser -u 1000 test

RUN make -C test/zdtm -j $(nproc)
