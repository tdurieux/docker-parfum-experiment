FROM debian:buster-backports

RUN apt update && \
    apt upgrade -y && \
    apt install --no-install-recommends -y \
        build-essential \
        cmake \
        ninja-build \
        python3-pip && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install --no-cache-dir conan

WORKDIR /app

COPY conanfile.txt ./

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN conan remote add bincrafters https://api.bintray.com/conan/bincrafters/public-conan && \
    conan remote add cyberduckninja https://api.bintray.com/conan/cyberduckninja/conan  && \
    conan install . --build missing -s build_type=Release -s compiler.libcxx=libstdc++11

COPY apps/rocketjoe_kernel/test/requirements.txt ./apps/rocketjoe_kernel/test/

RUN pip3 install --no-cache-dir -r apps/rocketjoe_kernel/test/requirements.txt

COPY . ./

WORKDIR ./build

ENV JUPYTER_PATH=/usr/local/share/jupyter

RUN cmake .. -GNinja -DCMAKE_BUILD_TYPE=Release -DDEV_MODE=ON && \
    cmake --build .
RUN  jupyter kernelspec install --user kernels/rocketjoe

CMD ctest -V
CMD pytest apps/rocketjoe_kernel/test/test_jupyter_kernel.py
CMD pytest apps/rocketjoe_kernel/test/test_jupyter_kernel_benchmark.py
CMD pytest apps/rocketjoe_kernel/test/test_jupyter_kernel_raw.py
