FROM ubuntu:15.10
MAINTAINER Yu Peng <loneknightpy@gmail.com>
RUN apt-get update
RUN apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pkg-config zip g++ zlib1g-dev unzip bash-completion wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc autoconf automake g++ make && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/bazelbuild/bazel/releases/download/0.2.0/bazel_0.2.0-linux-x86_64.deb
RUN dpkg -i bazel_0.2.0-linux-x86_64.deb
ADD . /root/idba
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN cd /root/idba && bazel build //:*
