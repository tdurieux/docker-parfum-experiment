FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive

#
# - update our repo
#
RUN apt-get -y update
RUN apt-get -y upgrade

#
# - install git
#
RUN apt-get -y --no-install-recommends install python python-pip git && rm -rf /var/lib/apt/lists/*;

#
# - install jdk8 from oracle
#
RUN apt-get install --no-install-recommends -y python-software-properties software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install --no-install-recommends -y oracle-java8-installer && rm -rf /var/lib/apt/lists/*;

#
# - install building tools
#
RUN apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libtool && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y autoconf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y automake && rm -rf /var/lib/apt/lists/*;

#
# - install libzmq-master
#
RUN git clone --depth 1 https://github.com/zeromq/libzmq.git
RUN cd libzmq && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && sudo make install && sudo ldconfig

#
# - install zeromq-3.2.3
#
RUN wget https://download.zeromq.org/zeromq-3.2.3.zip
RUN unzip zeromq-3.2.3.zip
RUN cd zeromq-3.2.3 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && sudo make install && sudo ldconfig

#
# - install jzmq
#
RUN git clone --depth 1 https://github.com/zeromq/jzmq.git
RUN cd jzmq && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && sudo make install && sudo ldconfig

#
# - set java.library.path
#
ENV LD_LIBRARY_PATH /usr/local/lib:/usr/local/share/java

#
# - remove defunct packages
#
RUN apt-get -y autoremove

#
# - copy lib files to docker default lib directory
#
RUN cp /usr/local/lib/libzmq.so.3.0.0 /lib/libzmq.so
RUN cp /usr/local/lib/libjzmq.so.0.0.0 /lib/libjzmq.so
