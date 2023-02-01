FROM java:openjdk-8-jdk

ENV MAVEN_VERSION 3.3.9

RUN mkdir -p /usr/share/maven \
  && curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | tar -xzC /usr/share/maven --strip-components=1 \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

VOLUME /root/.m2

RUN \
  apt-get update && \
  apt-get install -y build-essential cmake zlib1g-dev pkg-config libssl-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG HADOOP_VERSION=
ARG PROTOBUF_VERSION=

ADD \
  hadoop-${HADOOP_VERSION}-src.tar.gz \
  protobuf-${PROTOBUF_VERSION}.tar.bz2 \
  /tmp/

RUN \
  cd /tmp/protobuf-${PROTOBUF_VERSION} && \
  ./configure && \
  make -j$(nproc) && make install

ENV LD_LIBRARY_PATH /usr/local/lib
ENV export LD_RUN_PATH /usr/local/lib

# build native libs
RUN \
  cd /tmp/hadoop-${HADOOP_VERSION}-src && \
  mvn package -Pdist,native -DskipTests -Dtar

# tar to stdout
CMD tar -cv -C /tmp/hadoop-${HADOOP_VERSION}-src/hadoop-dist/target/hadoop-${HADOOP_VERSION}/lib/native/ .
