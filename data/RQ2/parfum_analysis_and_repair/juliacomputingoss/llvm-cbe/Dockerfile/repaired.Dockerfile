FROM buildpack-deps:stretch

RUN \
  set -e; \
  apt update && apt install --no-install-recommends -y \
    clang \
    ninja-build \
    cmake; rm -rf /var/lib/apt/lists/*; \
  cd /root; \
  curl -fL https://releases.llvm.org/8.0.0/llvm-8.0.0.src.tar.xz \
    | tar xJf -; \
  mv /root/llvm-8.0.0.src /root/llvm; \
  mkdir -p /root/llvm/build;

COPY . /root/llvm/projects/llvm-cbe/

RUN \
  set -e; \
  mkdir -p /root/llvm/build; \
  cd /root/llvm/build; \
  cmake -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..; \
  ninja llvm-cbe; \
  ninja lli; \
  ninja CBEUnitTests; \
  /root/llvm/build/projects/llvm-cbe/unittests/CWriterTest; \
  ln -s /root/llvm/build/bin/llvm-cbe /bin/llvm-cbe;
