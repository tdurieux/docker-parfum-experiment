FROM bernddoser/docker-devel-cpp:ubuntu-16.04-cmake-3.10

LABEL maintainer="Bernd Doser <bernd.doser@braintwister.eu>"

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
 && echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-4.0 main" >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install --no-install-recommends -y clang-4.0 lldb-4.0 \
 && apt-get clean \
 && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-4.0 100 \
 && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-4.0 100 && rm -rf /var/lib/apt/lists/*;

ENV CC clang
ENV CXX clang++
