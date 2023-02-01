FROM ubuntu:xenial AS xenial

RUN apt update;
RUN apt install --no-install-recommends -y wget curl tree git gcc build-essential kbuild libelf-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install linux-headers-4.10.*-generic || true && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install linux-headers-4.11.*-generic || true && rm -rf /var/lib/apt/lists/*;

RUN apt clean all

ADD . /elkeid
WORKDIR /elkeid/driver
RUN bash ./batch_compile.sh

RUN apt-get -y remove linux-headers-4.10.*-generic  || true
RUN apt-get -y remove linux-headers-4.11.*-generic  || true