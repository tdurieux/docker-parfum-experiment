FROM node:10-stretch

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch main" | tee -a /etc/apt/sources.list && \
    apt update -qq && \
    apt install --no-install-recommends libz-dev cmake clang git llvm-8 llvm-8-dev -y && \
    ln -s /usr/bin/llvm-config-8 /usr/bin/llvm-config && rm -rf /var/lib/apt/lists/*;
