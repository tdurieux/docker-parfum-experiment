FROM debian:buster

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common wget gnupg && rm -rf /var/lib/apt/lists/*;
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-add-repository "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-8 main" && apt-get update
RUN apt-get install --no-install-recommends -y clang-8 libclang-8-dev llvm-8-dev cmake git wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libspdlog-dev nlohmann-json-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libmlpack-dev && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/clang-8 /usr/bin/clang && ln -s /usr/bin/llvm-config-8 /usr/bin/llvm-config

RUN git clone https://github.com/aspire-project/chisel
RUN git clone https://github.com/aspire-project/chiselbench

RUN mkdir -p chisel/build && cd chisel/build && CXX=clang cmake .. && make

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/chisel/build/bin
ENV CC clang
ENV CHISEL_BENCHMARK_HOME /chiselbench
