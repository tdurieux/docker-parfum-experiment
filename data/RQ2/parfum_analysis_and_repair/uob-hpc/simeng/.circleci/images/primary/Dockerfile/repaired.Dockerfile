FROM buildpack-deps:bionic

# Install dependencies
RUN \
  echo deb https://apt.kitware.com/ubuntu/ bionic main \
    >> /etc/apt/sources.list && \
  wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc \
    | apt-key add - && \
  echo deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-8 main \
    >> /etc/apt/sources.list && \
  wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
  apt-get update -yqq && \
  apt-get install --no-install-recommends -y cmake g++-7 g++-8 clang-5.0 clang-7 && \
  apt-get install --no-install-recommends -y llvm-8-dev && \
  apt-get install --no-install-recommends -y clang-format-8 && \
  ln -s /usr/bin/clang-format-8 /usr/bin/clang-format && rm -rf /var/lib/apt/lists/*;
