FROM ubuntu:xenial
MAINTAINER esteve@apache.org
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y --no-install-recommends locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
RUN apt-get install -y --no-install-recommends lsb-release software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver hkps.pool.sks-keyservers.net --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN apt-get update
RUN apt-get install -y --no-install-recommends libc6-i386 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends build-essential cmake git libssl-dev wget zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends python3-vcstool python3-empy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends automake pkg-config libtool && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends ccache && rm -rf /var/lib/apt/lists/*;
RUN useradd -ms /bin/bash nao
WORKDIR /home/nao
USER nao
ENV CC /home/nao/ctc/bin/i686-aldebaran-linux-gnu-cc
ENV CPP /home/nao/ctc/bin/i686-aldebaran-linux-gnu-cpp
ENV CXX /home/nao/ctc/bin/i686-aldebaran-linux-gnu-c++
ENV RANLIB /home/nao/ctc/bin/i686-aldebaran-linux-gnu-ranlib
ENV AR /home/nao/ctc/bin/i686-aldebaran-linux-gnu-ar
ENV AAL /home/nao/ctc/bin/i686-aldebaran-linux-gnu-aal
ENV LD /home/nao/ctc/bin/i686-aldebaran-linux-gnu-ld
ENV READELF /home/nao/ctc/bin/i686-aldebaran-linux-gnu-readelf
ENV CFLAGS -isysroot /home/nao/ctc/i686-aldebaran-linux-gnu/sysroot
ENV CPPFLAGS -I/home/nao/ctc/zlib/include -I/home/nao/ctc/bzip2/include -I/home/nao/ctc/openssl/include
ENV LDFLAGS -L/home/nao/ctc/zlib/lib -L/home/nao/ctc/bzip2/lib -L/home/nao/ctc/openssl/lib
