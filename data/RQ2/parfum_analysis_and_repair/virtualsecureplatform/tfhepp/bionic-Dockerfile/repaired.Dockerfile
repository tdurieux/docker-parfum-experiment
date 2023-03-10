FROM ubuntu:18.04

LABEL maintainer="nindanaoto <matsuoka.kotaro@gmail.com>"

RUN apt-get update && apt-get upgrade -y && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y clang make libssl-dev libomp-dev cmake git wget libgoogle-perftools-dev && git clone --recursive --depth 1 https://github.com/virtualsecureplatform/TFHEpp && git clone --recursive --depth 1 https://github.com/tfhe/tfhe.git && mkdir TFHEpp/build && mkdir tfhe/build && wget https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2.tar.gz && tar -zxvf cmake-3.20.2.tar.gz && rm cmake-3.20.2.tar.gz && rm -rf /var/lib/apt/lists/*;
# && git clone --recursive --depth 1 https://github.com/virtualsecureplatform/tfhe-10ms.git && mkdir tfhe-10ms/build

WORKDIR cmake-3.20.2

RUN ./bootstrap && make && make install

WORKDIR /TFHEpp/build

RUN cmake .. -DENABLE_TEST=ON -DCMAKE_CXX_COMPILER=clang++ && make

WORKDIR /tfhe/build

RUN cmake ../src -DENABLE_TESTS=on -DENABLE_NAYUKI_PORTABLE=off -DENABLE_NAYUKI_AVX=off -DENABLE_SPQLIOS_AVX=off -DENABLE_SPQLIOS_FMA=on -DCMAKE_BUILD_TYPE=optim && make

# WORKDIR /tfhe-10ms/build

# RUN cmake ../src -DENABLE_TESTS=on -DENABLE_NAYUKI_PORTABLE=off -DENABLE_NAYUKI_AVX=off -DENABLE_SPQLIOS_AVX=off -DENABLE_SPQLIOS_FMA=on -DCMAKE_BUILD_TYPE=optim && make

WORKDIR /

CMD echo "TFHEpp" &&./TFHEpp/build/test/nand && echo "original TFHE" && ./tfhe/build/test/test-gate-bootstrapping-spqlios-fma
# && echo "TFHE-10ms" && tfhe-10ms/build/test/test-bootstrapping-fft-spqlios-fma
