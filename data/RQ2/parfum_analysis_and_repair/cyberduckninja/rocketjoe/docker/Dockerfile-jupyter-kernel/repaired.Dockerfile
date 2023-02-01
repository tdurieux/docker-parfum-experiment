FROM debian:buster-backports

RUN apt update && \
    apt upgrade -y && \
    apt install --no-install-recommends -y \
        build-essential \
        cmake \
        ninja-build \
        python3-pip \
        ipython3 \
        jupyter && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install --no-cache-dir conan

WORKDIR /app

COPY conanfile.txt ./

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN conan remote add bincrafters https://api.bintray.com/conan/bincrafters/public-conan && \
    conan remote add cyberduckninja https://api.bintray.com/conan/cyberduckninja/conan && \
    conan install . --build missing -s build_type=Release -s compiler.libcxx=libstdc++11

COPY . ./

WORKDIR ./build

RUN cmake .. -GNinja -DCMAKE_BUILD_TYPE=Release         && \
    cmake --build .  --target rocketjoe_kernel          && \
    jupyter kernelspec install --user kernels/rocketjoe && \
    mkdir -p rocketjoe

WORKDIR rocketjoe

CMD jupyter notebook --no-browser --allow-root \
        --NotebookApp.allow_remote_access=True --NotebookApp.ip=0.0.0.0

EXPOSE 8888
