# Base image for mesos-overlay-modules unit-test.
FROM ubuntu:14.04

RUN apt-get update && \
  apt-get install --no-install-recommends -y git && \
  apt-get install --no-install-recommends -y autoconf libtool && \
  apt-get -y --no-install-recommends install build-essential python-dev libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev libsvn-dev && \
  apt-get install --no-install-recommends -y ccache && \
  apt-get install --no-install-recommends -y clang && \
  apt-get install --no-install-recommends -y wget && \
  apt-get install --no-install-recommends -y ipset && rm -rf /var/lib/apt/lists/*;

# Install docker client.
RUN apt-get update && \
  apt-get -y --no-install-recommends install apt-transport-https ca-certificates && \
  apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
  echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list && \
  apt-get update && \
  apt-get -y --no-install-recommends install docker-engine && rm -rf /var/lib/apt/lists/*;

# Download Mesos source.
RUN wget https://www.apache.org/dist/mesos/1.0.0/mesos-1.0.0.tar.gz && \
 tar -zxf mesos-1.0.0.tar.gz && rm mesos-1.0.0.tar.gz
RUN rm -rf mesos-1.0.0.tar.gz

# Build Mesos source and install module dependency.
WORKDIR mesos-1.0.0
RUN mkdir build
RUN ./bootstrap
WORKDIR build
ENV CC "ccache clang -Qunused-arguments"
ENV CXX "ccache clang++ -Qunused-arguments"
ENV MESOS_INSTALL /mesos_install
RUN mkdir $MESOS_INSTALL
RUN ../configure --disable-java --disable-python --prefix=$MESOS_INSTALL --enable-install-module-dependencies
RUN make install
RUN ls -al $MESOS_INSTALL
