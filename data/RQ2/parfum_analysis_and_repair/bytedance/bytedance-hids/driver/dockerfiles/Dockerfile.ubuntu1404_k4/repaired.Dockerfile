FROM ubuntu:trusty AS trusty

RUN apt update;
RUN apt install --no-install-recommends -y wget curl tree git gcc build-essential kbuild libelf-dev; rm -rf /var/lib/apt/lists/*;

ADD . /elkeid
WORKDIR /elkeid/driver

RUN apt-get -y --no-install-recommends install linux-headers-4.2.*-generic || true && rm -rf /var/lib/apt/lists/*;
RUN bash ./batch_compile.sh
RUN apt-get -y remove linux-headers-4.2.*-generic || true

RUN apt-get -y --no-install-recommends install linux-headers-4.4.*-generic || true && rm -rf /var/lib/apt/lists/*;
RUN bash ./batch_compile.sh
RUN apt-get -y remove linux-headers-4.4.*-generic || true

RUN apt-get -y --no-install-recommends install linux-headers-4.15.*-generic || true && rm -rf /var/lib/apt/lists/*;
RUN bash ./batch_compile.sh
RUN apt-get -y remove linux-headers-4.15.*-generic || true


