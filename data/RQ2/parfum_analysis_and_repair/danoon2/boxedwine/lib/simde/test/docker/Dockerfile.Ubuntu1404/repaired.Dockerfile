#trusty with gcc 4.8.4
FROM ubuntu:14.04
RUN apt-get update && apt-get install --no-install-recommends -y gcc g++ wget unzip software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa && apt-get update && apt-get install -y --no-install-recommends python3.6 && rm -rf /var/lib/apt/lists/*;
RUN wget https://bootstrap.pypa.io/get-pip.py && python3.6 get-pip.py && rm get-pip.py && python3.6 -m pip install meson
RUN wget https://github.com/ninja-build/ninja/releases/download/v1.10.0/ninja-linux.zip && unzip ninja-linux.zip && mv ninja /usr/bin && rm -Rf ninja-linux*
COPY . /simde
WORKDIR /simde
RUN mkdir -p build_ubuntu14.04
WORKDIR /simde/build_ubuntu14.04
RUN CC=/usr/bin/gcc CXX=/usr/bin/g++ CFLAGS="-Wall -Wextra -Werror -Werror=unused-but-set-variable" CXXFLAGS="-Wall -Wextra -Werror -Werror=unused-but-set-variable" meson .. \
 && ninja -v && test/run-tests
