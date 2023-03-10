# EmptyHeaded Docker for Ubuntu 12.04 LTS
FROM ubuntu:14.04
MAINTAINER Christopher Aberger <craberger@gmail.com>

# update apt repositories
RUN apt-get update

# install add-apt-repository tool
RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python-software-properties -y && rm -rf /var/lib/apt/lists/*;

# install wget for downloading files
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install --no-install-recommends -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN add-apt-repository ppa:ubuntu-toolchain-r/test && apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    python \
    make \
    python-dev \
    python-pip \
    g++-5 \
    libtbb-dev \
    clang-format-3.4 \
    vim \
    pkg-config \
    screen \
    cmake \
    libjemalloc-dev && rm -rf /var/lib/apt/lists/*;

RUN mv /usr/bin/clang-format-3.4 /usr/bin/clang-format
RUN apt-get install --no-install-recommends -y firefox && rm -rf /var/lib/apt/lists/*;

#install scala
RUN wget https://dl.bintray.com/sbt/debian/sbt-0.13.7.deb
RUN dpkg -i sbt-0.13.7.deb
RUN apt-get install -y --no-install-recommends sbt && rm -rf /var/lib/apt/lists/*;
RUN sbt #pulls sbt which is timely

#install python add ons
RUN wget https://repo.continuum.io/miniconda/Miniconda-3.8.3-Linux-x86_64.sh -O miniconda.sh
RUN chmod +x miniconda.sh
RUN ./miniconda.sh -b -p /mc
ENV PATH=/mc/bin:$PATH
RUN /mc/bin/conda install -y cython
RUN /mc/bin/conda install -y pandas
RUN /mc/bin/conda install -y setuptools

ADD . /EmptyHeaded
WORKDIR "/EmptyHeaded/dependencies"
RUN ./install.sh
WORKDIR "/EmptyHeaded"
