FROM centos:centos7
RUN yum update -y && \
    yum install -y centos-release-scl && \
    yum install -y \
	autoconf \
	automake \
	boost-devel \
	cairomm-devel \
	devtoolset-7 \
	make \
	pangomm-devel \
	python3-devel \
	python3-pip \
    	git \
    	sqlite-devel \
	&& \
    yum clean all && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir xattr
ADD build /build
VOLUME /src
WORKDIR /src
CMD /build
