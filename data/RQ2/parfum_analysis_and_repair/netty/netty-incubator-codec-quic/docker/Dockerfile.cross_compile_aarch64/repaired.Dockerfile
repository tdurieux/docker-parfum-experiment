FROM centos:7.6.1810

ARG GCC_VERSION=10.2-2020.11
ENV SOURCE_DIR /root/source
ENV WORKSPACE_DIR /root/workspace
ENV PROJECT_DIR /root/workspace/project

# We want to have git 2.x for the maven scm plugin and also for boringssl
RUN yum install -y http://opensource.wandisco.com/centos/6/git/x86_64/wandisco-git-release-6-1.noarch.rpm && rm -rf /var/cache/yum

RUN yum -y install epel-release && rm -rf /var/cache/yum

# Install requirements
RUN yum install -y \
 apr-devel \
 autoconf \
 automake \
 bzip2 \
 git \
 glibc-devel \
 golang \
 gnupg \
 libtool \
 lsb-core \
 ninja-build \
 make \
 perl \
 tar \
 unzip \
 wget && rm -rf /var/cache/yum


RUN mkdir $SOURCE_DIR
WORKDIR $SOURCE_DIR

# Install Java
RUN yum install -y java-1.8.0-openjdk-devel golang && rm -rf /var/cache/yum
ENV JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk/"

# Install aarch64 gcc 10.2 toolchain
RUN wget https://developer.arm.com/-/media/Files/downloads/gnu-a/$GCC_VERSION/binrel/gcc-arm-$GCC_VERSION-x86_64-aarch64-none-linux-gnu.tar.xz && \
  tar xvf gcc-arm-$GCC_VERSION-x86_64-aarch64-none-linux-gnu.tar.xz && mv gcc-arm-$GCC_VERSION-x86_64-aarch64-none-linux-gnu /opt/ && rm gcc-arm-$GCC_VERSION-x86_64-aarch64-none-linux-gnu.tar.xz
ENV PATH="/opt/gcc-arm-$GCC_VERSION-x86_64-aarch64-none-linux-gnu/bin:${PATH}"

# Install CMake
RUN yum install -y cmake3 && ln -s /usr/bin/cmake3 /usr/bin/cmake && rm -rf /var/cache/yum

# install rust and setup PATH and install correct toolchain
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="$HOME/.cargo/bin:${PATH}"
RUN /root/.cargo/bin/rustup target add aarch64-unknown-linux-gnu

# Setup the correct linker
RUN echo '[target.aarch64-unknown-linux-gnu]' >> /root/.cargo/config
RUN echo 'linker = "aarch64-none-linux-gnu-gcc"' >> /root/.cargo/config

WORKDIR /opt
RUN curl -f https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz | tar -xz
RUN echo 'PATH=/opt/apache-maven-3.6.3/bin/:$PATH' >> ~/.bashrc

# Prepare our own build
ENV PATH /opt/apache-maven-3.6.3/bin/:$PATH