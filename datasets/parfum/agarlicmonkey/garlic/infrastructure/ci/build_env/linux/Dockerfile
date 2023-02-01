FROM gcc:10 as cmake_builder

RUN apt-get install -y git

#Get cmake build requirements
RUN apt-get install -y make
RUN apt-get install -y libssl-dev

#Build Cmake
RUN git clone --branch v3.18.3 --depth 1 https://gitlab.kitware.com/cmake/cmake.git
WORKDIR /cmake/
RUN ./bootstrap --prefix=/cmake_install
RUN make 
RUN make install

FROM ubuntu:20.04

RUN apt-get update -y --fix-missing
RUN apt-get install -y

#Install any utilities
RUN apt-get install -y git
RUN apt-get install -y make
RUN apt-get install -y wget
RUN apt-get install -y python3.4
RUN apt-get install -y python3-pip

#Install the compilers
RUN apt-get install -y g++-10
RUN apt-get install -y clang-10

#Install cmake
COPY --from=cmake_builder /cmake_install /cmake_install
ENV PATH "/cmake_install/bin:$PATH"

#Install conan
RUN pip3 install conan

#Install X11
RUN apt-get install -y libx11-dev

#Install Vulkan
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y gnupg2
RUN apt-get install -y ca-certificates wget
RUN wget -qO - https://packages.lunarg.com/lunarg-signing-key-pub.asc | apt-key add -
RUN wget -qO /etc/apt/sources.list.d/lunarg-vulkan-1.2.154-focal.list https://packages.lunarg.com/vulkan/1.2.154/lunarg-vulkan-1.2.154-focal.list
RUN apt-get update -y
RUN apt-get install -y vulkan-sdk

CMD [ "/bin/bash" ]