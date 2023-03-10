FROM ornladios/adios2:ci-spack-el8-base

# Install build dependencies (Clang requires a newer GCC to build)
RUN dnf install -y elfutils-devel && \
    dnf install -y cmake ninja-build gcc-toolset-11

# Install the clang compilers from source
RUN cd /opt && \
    mkdir clang && \
    cd clang && \
    curl -f -L -O https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.1/llvm-project-13.0.1.src.tar.xz && \
    tar -xvf llvm-project-13.0.1.src.tar.xz && \
    mkdir build && \
    cd build && \
    . /opt/rh/gcc-toolset-11/enable && \
    cmake \
      -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/opt/clang/13.0.1 \
      -DLLVM_REQUIRES_RTTI=TRUE \
      -DLLVM_ENABLE_RTTI=TRUE \
      -DLLVM_ENABLE_EH=TRUE \
      -DLLVM_BUILD_LLVM_DYLIB=ON \
      -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
      -DLLVM_TARGETS_TO_BUILD=X86 \
      -DLLVM_ENABLE_PROJECTS="clang;flang;lld;openmp;clang-tools-extra;libcxx;libcxxabi;compiler-rt;pstl;mlir" \
      ../llvm-project-13.0.1.src/llvm && \
    ninja install && rm llvm-project-13.0.1.src.tar.xz

# Remove build-time dependencies (leave elf-utils for OpenMP to work)
RUN rm -rf /opt/clang/llvm* /opt/clang/build && \
    dnf autoremove -y cmake ninja-build gcc-toolset-11 && \
    dnf install -y gcc-gfortran && \
    dnf clean all

# Add compilers to spack
RUN . /opt/spack/share/spack/setup-env.sh && \
    spack compiler add --scope system \
      /opt/clang/13.0.1 && \
    spack config --scope=system add 'packages:all:compiler: [clang, gcc]' && \
    sed \
      -e '15,100 s|f77: null|f77: /opt/clang/13.0.1/bin/flang|' \
      -e '15,100 s|fc: null|fc: /opt/clang/13.0.1/bin/flang|' \
      -i /etc/spack/compilers.yaml && \
    spack clean -a
