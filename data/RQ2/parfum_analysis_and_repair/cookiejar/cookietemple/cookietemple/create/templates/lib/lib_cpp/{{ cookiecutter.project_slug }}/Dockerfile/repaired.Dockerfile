FROM ubuntu:18.04

RUN echo "Updating Ubuntu"
RUN apt-get update && apt-get upgrade -y

RUN echo "Installing dependencies..."
RUN apt install --no-install-recommends -y \
			ccache \
			clang \
			clang-format \
			clang-tidy \
			cppcheck \
			curl \
			doxygen \
			gcc \
			git \
			graphviz \
			make \
			ninja-build \
			python3 \
			python3-pip \
			tar \
			unzip \
			vim && rm -rf /var/lib/apt/lists/*;

RUN echo "Installing dependencies not found in the package repos..."

RUN apt install --no-install-recommends -y wget tar build-essential libssl-dev && \
			wget https://github.com/Kitware/CMake/releases/download/v3.15.0/cmake-3.15.0.tar.gz && \
			tar -zxvf cmake-3.15.0.tar.gz && \
			cd cmake-3.15.0 && \
			./bootstrap && \
			make && \
			make install && rm cmake-3.15.0.tar.gz && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir conan

RUN git clone https://github.com/catchorg/Catch2.git && \
		 cd Catch2 && \
		 cmake -Bbuild -H. -DBUILD_TESTING=OFF && \
		 cmake --build build/ --target install

# Disabled pthread support for GTest due to linking errors
RUN git clone https://github.com/google/googletest.git --branch release-1.10.0 && \
        cd googletest && \
        cmake -Bbuild -Dgtest_disable_pthreads=1 && \
        cmake --build build --config Release && \
        cmake --build build --target install --config Release

RUN git clone https://github.com/microsoft/vcpkg -b 2020.06 && \
		cd vcpkg && \
		./bootstrap-vcpkg.sh -disableMetrics -useSystemBinaries
