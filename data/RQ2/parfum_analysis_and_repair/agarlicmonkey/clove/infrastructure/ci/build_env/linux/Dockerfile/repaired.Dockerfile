FROM gcc:10 as cmake_builder

RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

#Get cmake build requirements
RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;

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
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3.4 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

#Install the compilers
RUN apt-get install --no-install-recommends -y g++-10 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y clang-10 && rm -rf /var/lib/apt/lists/*;

#Install cmake
COPY --from=cmake_builder /cmake_install /cmake_install
ENV PATH "/cmake_install/bin:$PATH"

#Install conan
RUN pip3 install --no-cache-dir conan

#Install X11
RUN apt-get install --no-install-recommends -y libx11-dev && rm -rf /var/lib/apt/lists/*;

#Install Vulkan
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install --no-install-recommends -y gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ca-certificates wget && rm -rf /var/lib/apt/lists/*;
RUN wget -qO - https://packages.lunarg.com/lunarg-signing-key-pub.asc | apt-key add -
RUN wget -qO /etc/apt/sources.list.d/lunarg-vulkan-1.2.154-focal.list https://packages.lunarg.com/vulkan/1.2.154/lunarg-vulkan-1.2.154-focal.list
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y vulkan-sdk && rm -rf /var/lib/apt/lists/*;

CMD [ "/bin/bash" ]