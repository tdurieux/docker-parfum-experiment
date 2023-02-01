# Steps:
# 1. docker build --no-cache -t opencog/destin .
# 2. docker run --rm -it opencog/destin

# For X Windows systems run:
# docker run --rm -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=:0 -it opencog/destin

FROM ubuntu:16.04
MAINTAINER Jacek Świergocki "jswiergo@gmail.com"

# Avoid triggering apt-get dialogs (which may lead to errors). See:
# http://stackoverflow.com/questions/25019183/docker-java7-install-fail
ENV DEBIAN_FRONTEND noninteractive

ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

RUN apt-get update ; apt-get -y upgrade ; apt-get -y autoclean

# Install tools for developers.
RUN apt-get -y --no-install-recommends install software-properties-common wget rlwrap telnet less \
                       netcat-openbsd curl vim tmux man git valgrind gdb sudo && rm -rf /var/lib/apt/lists/*;

# GCC and basic build tools
RUN apt-get -y --no-install-recommends install gcc g++ make cmake && rm -rf /var/lib/apt/lists/*;

# Java
RUN apt-get install --no-install-recommends software-properties-common -y; rm -rf /var/lib/apt/lists/*; \
    add-apt-repository ppa:webupd8team/java -y; \
    apt-get update -y; \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections; \
    apt-get install --no-install-recommends oracle-java7-installer ant libcommons-logging-java libxtst6 -y

# OpenCV
RUN apt-get -y --no-install-recommends install libopencv-dev && rm -rf /var/lib/apt/lists/*;

# Python
RUN apt-get -y --no-install-recommends install python-dev python-opencv python-matplotlib idle && rm -rf /var/lib/apt/lists/*;

# Create and switch user. The user is privileged with no password required
RUN adduser --disabled-password --gecos "OpenCog Developer" opencog
RUN adduser opencog sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER opencog
WORKDIR /home/opencog

# SWIG 2.x
RUN wget https://sourceforge.net/projects/swig/files/swig/swig-2.0.12/swig-2.0.12.tar.gz
RUN tar -zxf swig-2.0.12.tar.gz; rm swig-2.0.12.tar.gz cd swig-2.0.12; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
    make -j$(nproc); sudo make install; cd ..

# Destin
RUN git clone http://github.com/opencog/destin.git;\
    cd destin; git submodule init; git submodule update;\
    cd Destin; cmake .; make -j$(nproc);

# Ciphar Data
RUN cd ~/destin/Destin/Data; wget https://www.cs.toronto.edu/~kriz/cifar-10-binary.tar.gz; \
    tar -xzf cifar-10-binary.tar.gz; rm cifar-10-binary.tar.gz

CMD /bin/bash
