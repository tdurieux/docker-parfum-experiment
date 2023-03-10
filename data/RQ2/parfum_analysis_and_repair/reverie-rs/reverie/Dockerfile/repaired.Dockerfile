FROM ubuntu:18.04

# Icky nondeterminism:
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y g++ make strace python3 libseccomp-dev openssh-server fuse libfuse-dev less valgrind && rm -rf /var/lib/apt/lists/*;

# RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y software-properties-common clang-6.0 clang++-6.0 lldb-6.0 lld-6.0 && rm -rf /var/lib/apt/lists/*;

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y pkg-config libarchive-dev libacl1-dev liblzo2-dev liblzma-dev liblz4-dev libbz2-dev libxml2-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y cpio curl && rm -rf /var/lib/apt/lists/*;

RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-6.0 60 \
		--slave /usr/bin/clang++ clang++ /usr/bin/clang++-6.0 \
		--slave /usr/bin/clang-cpp clang-cpp /usr/bin/clang-cpp-6.0 \
		--slave /usr/bin/lldb lldb /usr/bin/lldb-6.0

# install toolchain
RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- --default-toolchain nightly -y

ENV PATH=/root/.cargo/bin:$PATH

ADD ./ /reverie

RUN cd /reverie/ && make

WORKDIR /reverie
