FROM ubuntu
MAINTAINER <peter@goldsborough.me>

# Install packages.
RUN apt-get update  -y \
 && apt-get install --no-install-recommends -y git cmake vim make wget gnupg && rm -rf /var/lib/apt/lists/*;

# Get LLVM apt repositories.
RUN wget -O - 'https://apt.llvm.org/llvm-snapshot.gpg.key' | apt-key add - \
 && echo 'deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main' \
    >> /etc/apt/sources.list \
 && echo 'deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main' \
    >> /etc/apt/sources.list

# Install clang-3.9
RUN apt-get update -y && apt-get install --no-install-recommends -y clang-3.9 && rm -rf /var/lib/apt/lists/*;

ENV C clang-3.9
ENV CXX clang++-3.9

# Grab LLVM and clang.
RUN git clone --progress --verbose \
    https://github.com/llvm-mirror/llvm.git llvm
RUN git clone --progress --verbose \
    https://github.com/llvm-mirror/clang.git llvm/tools/clang

# These volumes should be mounted as named volumes.
VOLUME /llvm/build /home/build

# These volumes should be mounted on the host.
VOLUME /home/project /home/build/bin

WORKDIR /home
COPY build.sh .
CMD ["./build.sh", "ubuntu"]
