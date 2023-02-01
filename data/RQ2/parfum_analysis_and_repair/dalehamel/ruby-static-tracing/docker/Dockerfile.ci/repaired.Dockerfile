FROM ubuntu:18.10 as builder
ENV RUN_TESTS=0

RUN apt-get update && apt-get install --no-install-recommends -y git wget gnupg && rm -rf /var/lib/apt/lists/* && apt-get clean

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
COPY sources.list /etc/apt/sources.list.d/llvm.list

RUN wget -O - https://repo.iovisor.org/GPG-KEY | apt-key add -
RUN echo "deb https://repo.iovisor.org/apt/bionic bionic main" > /etc/apt/sources.list.d/iovisor.list

RUN apt-get update

RUN apt-get install --no-install-recommends -y bison cmake flex vim g++ libelf-dev zlib1g-dev libfl-dev curl git bc && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y systemtap-sdt-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y clang-5.0 libclang-5.0-dev libclang-common-5.0-dev libclang1-5.0 libllvm5.0 llvm-5.0 llvm-5.0-dev llvm-5.0-runtime && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y clang-format-6.0 && ln -s /usr/bin/clang-format-6.0 /usr/bin/clang-format && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libbcc=0.9.0-1 bcc-tools && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN echo 'PATH="$PATH:/usr/share/bcc/tools"' >> /etc/bash.bashrc

RUN apt-get install --no-install-recommends -y ruby ruby-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN gem install bundler

COPY scripts/fetch-linux-headers.sh /tmp/fetch-linux-headers.sh
RUN /tmp/fetch-linux-headers.sh

ADD https://github.com/iovisor/bpftrace/archive/v0.9.tar.gz /bpftrace.tar.gz
RUN tar -xvf /bpftrace.tar.gz && rm /bpftrace.tar.gz

RUN mv bpftrace-0.9 /bpftrace

RUN mkdir /bpftrace/build

WORKDIR /bpftrace/build

RUN cmake -DCMAKE_BUILD_TYPE=DEBUG -DCMAKE_INSTALL_PREFIX=/usr/local/ ..
RUN make -j9
RUN make install

WORKDIR /app
