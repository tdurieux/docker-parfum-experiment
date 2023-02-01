# kubos/kubos-dev:0.0.6

FROM phusion/baseimage:0.9.22

MAINTAINER kyle@kubos.co

RUN add-apt-repository -y ppa:team-gcc-arm-embedded/ppa
RUN add-apt-repository -y ppa:george-edison55/cmake-3.x
RUN add-apt-repository -y ppa:git-core/ppa

RUN apt-get update -y

RUN apt-get upgrade -y python2.7
RUN apt-get install --no-install-recommends -y build-essential libssl-dev libffi-dev libhidapi-hidraw0 clang && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-setuptools build-essential ninja-build python-dev libffi-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc-arm-embedded && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc-msp430 gdb-msp430 msp430-libc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libdbus-1-dev dbus && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unzip wget && rm -rf /var/lib/apt/lists/*;

# Legacy BBB toolchain
RUN apt-get install --no-install-recommends -y crossbuild-essential-armhf gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf && rm -rf /var/lib/apt/lists/*;

#do the pip setup and installation things
RUN easy_install pip
RUN pip install --no-cache-dir --upgrade pip

#KubOS Linux setup
RUN echo "Installing KubOS Linux Toolchain"

RUN apt-get install --no-install-recommends -y minicom && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libc6-i386 lib32stdc++6 lib32z1 && rm -rf /var/lib/apt/lists/*;

RUN wget https://s3.amazonaws.com/kubos-provisioning/iobc_toolchain.tar.gz
RUN tar -xf ./iobc_toolchain.tar.gz -C /usr/bin && rm ./iobc_toolchain.tar.gz
RUN rm ./iobc_toolchain.tar.gz

RUN wget https://s3.amazonaws.com/kubos-provisioning/bbb_toolchain.tar.gz
RUN tar -xf ./bbb_toolchain.tar.gz -C /usr/bin && rm ./bbb_toolchain.tar.gz
RUN rm ./bbb_toolchain.tar.gz

RUN pip install --no-cache-dir pysocks
RUN pip install --no-cache-dir mock
RUN pip install --no-cache-dir --upgrade setuptools
RUN pip install --no-cache-dir git+https://github.com/kubos/kubos-cli
RUN pip install --no-cache-dir cryptography==1.9

RUN mkdir -p /usr/local/lib/yotta_modules
RUN mkdir -p /usr/local/lib/yotta_targets
RUN mkdir -p /home/vagrant/.kubos

ENV PATH "$PATH:/usr/bin/iobc_toolchain/usr/bin:/usr/bin/bbb_toolchain/usr/bin"

# D-Bus setup/init stufff
# Create a D-bus init script and put the conf in place
RUN mkdir -p /etc/my_init.d
ADD dbus_environment.sh /etc/my_init.d/dbus_environment.sh
RUN chmod +x /etc/my_init.d/dbus_environment.sh
ADD kubos.conf /etc/dbus-1/kubos.conf

# Export neccesary env variables
ENV DBUS_SESSION_BUS_ADDRESS "unix:path=/tmp/kubos"
ENV DBUS_STARTER_BUS_TYPE "session"
