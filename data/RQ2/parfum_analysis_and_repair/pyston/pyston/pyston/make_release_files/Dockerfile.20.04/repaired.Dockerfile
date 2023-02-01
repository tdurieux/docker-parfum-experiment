FROM ubuntu:20.04

# have to set this else apt will ask for a config for tzdata
ARG DEBIAN_FRONTEND=noninteractive

RUN echo 'deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted' >> /etc/apt/sources.list

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends -y build-essential ninja-build git cmake clang libssl-dev libsqlite3-dev luajit python3.8 zlib1g-dev virtualenv libjpeg-dev linux-tools-common linux-tools-generic && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y dh-make dh-exec debhelper patchelf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*; # used by the release script

# we have to set a local else it will use ascii
RUN apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# if we don't install this option packages our build will have way fewer functions
# e.g. no libreadline -> no repl history
RUN apt build-dep -y python3.8

# install dependencies for the test suite
RUN apt-get install --no-install-recommends -y libwebp-dev libjpeg-dev python3.8-gdbm python3.8-tk python3.8-dev tk-dev libgdbm-dev libgdbm-compat-dev liblzma-dev libbz2-dev nginx && rm -rf /var/lib/apt/lists/*;

# revert bolt patched llvm
RUN git config --global user.email "you@example.com"
RUN git config --global user.name "Your Name"
