ARG image=centos/centos:latest
FROM quay.io/$image

# Install dependencies
RUN yum update -y
RUN yum install -y autoconf automake gcc libtool make diffutils file && rm -rf /var/cache/yum

# Add source code
ADD . /src
WORKDIR /src

# Run steps
RUN ./bootstrap
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make check
RUN make distcheck
