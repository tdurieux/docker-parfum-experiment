FROM ubuntu:trusty AS trusty

RUN apt update;
RUN apt install --no-install-recommends -y wget curl tree git gcc build-essential kbuild libelf-dev; rm -rf /var/lib/apt/lists/*;

ADD . /elkeid
WORKDIR /elkeid/driver


RUN apt-get -y --no-install-recommends install linux-headers-3.13.*-generic || true && rm -rf /var/lib/apt/lists/*;
RUN bash ./batch_compile.sh
RUN apt-get -y remove linux-headers-3.13.*-generic || true

RUN apt-get -y --no-install-recommends install linux-headers-3.16.*-generic || true && rm -rf /var/lib/apt/lists/*;
RUN bash ./batch_compile.sh
RUN apt-get -y remove linux-headers-3.16.*-generic || true

RUN apt-get -y --no-install-recommends install linux-headers-3.19.*-generic || true && rm -rf /var/lib/apt/lists/*;
RUN bash ./batch_compile.sh
RUN apt-get -y remove linux-headers-3.19.*-generic || true



