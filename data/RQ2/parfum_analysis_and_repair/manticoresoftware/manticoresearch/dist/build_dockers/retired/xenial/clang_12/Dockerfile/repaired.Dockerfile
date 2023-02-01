FROM xenial_cmake:320

RUN apt -y update && \
 apt -y --no-install-recommends install apt-transport-https ca-certificates && \
 apt install --no-install-recommends -y lsb-release wget software-properties-common && \
wget https://apt.llvm.org/llvm.sh && \
chmod +x llvm.sh && \
./llvm.sh 12 && \
rm -rf /var/lib/apt/lists/*

ENV CC clang-12
ENV CXX clang++-12

CMD []
