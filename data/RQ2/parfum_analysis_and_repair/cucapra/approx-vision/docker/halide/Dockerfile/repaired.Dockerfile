FROM ubuntu
WORKDIR /root

# Install basics
RUN apt-get update && apt-get install --no-install-recommends -y \
	build-essential \
	git \
	cmake \
	wget \
	curl \
	vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y subversion \
	python && rm -rf /var/lib/apt/lists/*;

# Create packages directory
RUN mkdir /root/packages
WORKDIR /root/packages

# Get and build LLVM and CLANG
RUN svn co https://llvm.org/svn/llvm-project/llvm/branches/release_37 llvm3.7
RUN svn co https://llvm.org/svn/llvm-project/cfe/branches/release_37 llvm3.7/tools/clang
WORKDIR /root/packages/llvm3.7
RUN mkdir build
WORKDIR /root/packages/llvm3.7/build
RUN cmake -DLLVM_ENABLE_TERMINFO=OFF -DLLVM_TARGETS_TO_BUILD="X86;ARM;NVPTX;AArch64;Mips;PowerPC" -DLLVM_ENABLE_ASSERTIONS=ON -DCMAKE_BUILD_TYPE=Release ..
RUN make -j8

# Point halide to LLVM and CLANG
ENV LLVM_CONFIG /root/packages/llvm3.7/build/bin/llvm-config
ENV CLANG /root/packages/llvm3.7/build/bin/clang
ENV PATH /root/packages/llvm3.7/build/bin/llvm-config:/root/packages/llvm3.7/build/bin/clang:$PATH
ENV LLVM_ROOT=/root/packages/llvm3.7/build

# Get Halide
WORKDIR /root/packages
RUN git clone https://github.com/halide/Halide.git
WORKDIR /root/packages/Halide

# To prevent "cannot find -lz" error
RUN apt-get install --no-install-recommends -y zlib1g-dev \
	lib32z1-dev \
	libpng-dev && rm -rf /var/lib/apt/lists/*;

# Make Halide
RUN make -j8

# Add library files to path
ENV LD_LIBRARY_PATH /root/packages/Halide/bin:$LD_LIBRARY_PATH

# Re-set working directory
WORKDIR /root
