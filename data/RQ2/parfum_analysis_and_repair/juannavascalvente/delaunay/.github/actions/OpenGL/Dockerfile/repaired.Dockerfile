FROM ubuntu:latest
RUN apt-get -y update
RUN echo 8 | apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y apt-utils cmake freeglut3-dev mesa-utils libgtest-dev googletest build-essential && rm -rf /var/lib/apt/lists/*;
RUN cmake --version
WORKDIR /usr/src/gtest
RUN cmake CMakeLists.txt
RUN make
RUN cp lib/*.a /usr/lib
RUN ls -l /usr/lib/*.a