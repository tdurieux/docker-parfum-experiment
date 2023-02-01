FROM ubuntu:16.04

# Install
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y apt-utils | true && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common | true && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN apt-get update -y
RUN add-apt-repository -y ppa:jonathonf/gcc-7.1
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y cmake software-properties-common git make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc-7 g++-7 && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 90
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 90

# Build Preparation
RUN mkdir -p /src/
RUN mkdir -p /src/build/
RUN git clone https://github.com/ericniebler/range-v3.git
RUN cp -r range-v3/include/* /usr/local/include/.

# Build
WORKDIR /src/build/
COPY . /src/
RUN cmake ..
RUN make

# clean crud then find and execute all examples
RUN rm -rf CMake* && find . -type f -executable -exec '{}' ';'

