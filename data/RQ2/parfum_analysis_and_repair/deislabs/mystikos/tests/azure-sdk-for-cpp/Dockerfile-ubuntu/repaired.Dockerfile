FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y curl zip unzip tar git g++ wget build-essential libssl-dev libcurl4-openssl-dev libxml2-dev && rm -rf /var/lib/apt/lists/*;

# Install newer Cmake than ubuntu 18.04 offers
RUN curl -f -LO https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2-linux-x86_64.tar.gz \
 && tar xf cmake-3.20.2-linux-x86_64.tar.gz \
 && mv cmake-3.20.2-linux-x86_64/bin/* /usr/bin/ \
 && mv cmake-3.20.2-linux-x86_64/share/cmake-3.20 /usr/share/ \
 && rm -rf cmake-3.20.2-linux-x86_64* && rm cmake-3.20.2-linux-x86_64.tar.gz

RUN git clone https://github.com/microsoft/vcpkg

RUN ./vcpkg/bootstrap-vcpkg.sh

RUN git clone https://github.com/Azure/azure-sdk-for-cpp.git

RUN cd azure-sdk-for-cpp && mkdir build && cd build \
		&& cmake .. -DCMAKE_BUILD_TYPE=Debug -DBUILD_STORAGE_SAMPLES=ON -DBUILD_TESTING=ON \
		&& cmake --build .
