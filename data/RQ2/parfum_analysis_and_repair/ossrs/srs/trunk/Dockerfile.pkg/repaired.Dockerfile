FROM ossrs/srs:dev

# version=4.0.145
ARG version
ARG SRS_AUTO_PACKAGER

# Install depends tools.
RUN yum install -y zip && rm -rf /var/cache/yum

# Build and install SRS.
ADD srs-server-${version}.tar.gz /srs
WORKDIR /srs/srs-server-${version}/trunk
RUN ./scripts/package.sh --x86-x64 --jobs=2 --tag=${version}

