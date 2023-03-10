FROM centos:6

# Do this in its own "layer" before everything else
# because it will change rarely and it is huge (about 1.5GB).
# This way it will be cached separately.
COPY install/install-codesafe /tmp
RUN /tmp/install-codesafe && rm -f /tmp/install-codesafe

ENV CHAIN="/go/src/chain" \
    BUNDLE_APP_CONFIG="/usr/local/bundle" \
    GEM_HOME="/usr/local/bundle" \
    GOPATH="/go" \
    GOROOT="/usr/local/go" \
    JAVA_HOME="/opt/jdk1.7.0_80" \
    JRE_HOME="/opt/jdk1.7.0_80/jre" \
    MAVEN_HOME="/usr/share/maven" \
    PATH="$PATH:/go/src/chain/docker/ci/bin/:/usr/local/bundle/bin:/go/bin:/usr/local/go/bin:/opt/jdk1.7.0_80/bin:/opt/jdk1.7.0_80/jre/bin:/opt/nfast/bin"

ADD install /usr/bin

RUN yum -y update \
    && yum install -y autoconf automake bash bzip2 bzip2-devel curl gcc gcc-c++ git libtool make openssl-devel ruby snappy snappy-devel tar wget unzip \
    && install-go && rm -f /usr/bin/install-go \
    && install-rocksdb \
    && install-node && rm -f /usr/bin/install-node \
    && install-java && rm -f /usr/bin/install-java \
    && install-maven && rm -f /usr/bin/install-maven \
    && install-ruby && rm -f /usr/bin/install-ruby \
    && install-rust && rm -f /usr/bin/install-rust \
    && install-protobuf && rm -f /usr/bin/install-protobuf \
    && install-gas && rm -f /usr/bin/install-gas \
    && go get -u google.golang.org/grpc \
    && yum remove -y autoconf automake libtool gcc-c++ unzip \
    && yum clean all && rm -rf /var/cache/yum

