ARG COMPILER

FROM registry.gitlab.com/offa/docker-images/${COMPILER}:stable

RUN apt-get update && \
        apt-get install -y --no-install-recommends pkg-config qtbase5-dev  libusb-1.0-0-dev && \
        mkdir deps && cd deps && \
        if [ "$(echo ${CXX} | cut -c -5)" = "clang" ]; then \
            export CXXFLAGS="-stdlib=libc++"; \
        fi && \
        git clone --depth=1 --branch=release-1.12.1 https://github.com/google/googletest.git && \
        cd googletest && \
        mkdir build && cd build && \
        cmake -DCMAKE_CXX_STANDARD=17 .. && \
        make -j && make install && \
        cd ../.. && rm -rf deps
