#########
# Stage 1 - fetch build tools, fetch Tuplex source, and build it
FROM ubuntu:20.04 as builder

LABEL maintainer "Maintainer <tuplex@chervil.se>"
LABEL description="This is a Ubuntu Docker image for building the Tuplex compiler"

# Install general build tools
# Install software to fetch the Tuplex source, and needed LLVM components
RUN apt-get update && apt-get install -y \
    bison \
    cmake \
    make \
    gcc \
    g++ \
    curl \
    ca-certificates \
    unzip \
    libllvm11 \
    llvm-11-dev \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Add LLVM to path
ENV PATH $PATH:/usr/lib/llvm-11/bin

# Copy the Tuplex source from the host context
COPY compiler /usr/local/tuplex/compiler

# Build tuplex
# Create a Tuplex release bundle (without sources and build files)
RUN mkdir /usr/local/tuplex/compiler/build-release && \
    cd /usr/local/tuplex/compiler/build-release && \
    cmake .. && \
    make -j7 && \
    ../scripts/copytxrelease -nozip


#########
# Stage 2 - produce a small release image with build results
FROM ubuntu:20.04

LABEL maintainer "Maintainer <tuplex@chervil.se>"
LABEL description="This is a Ubuntu Docker image for running the Tuplex compiler"

# Install minimal software to run the Tuplex test suite, and the nano editor
RUN apt-get update && apt-get install -y \
    python3-minimal \
    libllvm11 \
    nano-tiny \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/tuplex/compiler/build-release/releases/latest /usr/local/tuplex/compiler

# Add Tuplex bin and scripts to path
ENV PATH /usr/local/tuplex/compiler/scripts:/usr/local/tuplex/compiler/bin:$PATH

# Set Tuplex' source path var