FROM ubuntu:bionic

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y linux-tools-common linux-tools-generic && rm -rf /var/lib/apt/lists/*;
RUN ln -sf /usr/lib/linux-tools/4.15.0-30-generic/perf /usr/bin/perf

WORKDIR /workdir

ADD . /workdir

RUN make clean simple-terminates forks