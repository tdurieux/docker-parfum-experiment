FROM ubuntu:latest

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install build-essential gcc cmake git googletest python3-pip && \
    pip3 install --no-cache-dir conan && conan profile new hosacpp --detect && \
    conan profile update settings.compiler.libcxx=libstdc++11 hosacpp && rm -rf /var/lib/apt/lists/*;

ADD . /usr/src

WORKDIR /usr/src

RUN mkdir build && \
    cd build && \
    conan install .. --build=missing -s build_type=Release -pr=hosacpp && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    cmake --build . && \
    cmake --install .

CMD /usr/local/bin/customer
