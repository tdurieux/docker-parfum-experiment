#
# To use this image to compile C and C++ projects, do something like
# docker build -t cppenv-http .
# docker run -v $PWD/hw_1:/source -it cppenv-http bash
#

# Get the GCC preinstalled image from Docker Hub
FROM gcc:4.9

MAINTAINER Eric Klavins "klavins@uw.edu"

# Get cmake for googletest, graphviz and doxygen for documentation
RUN apt-get update && \
    apt-get install --no-install-recommends -y cmake && \
    apt-get install --no-install-recommends -y cppcheck && \
    apt-get install --no-install-recommends -y graphviz && \
    apt-get install --no-install-recommends -y doxygen && \
    apt-get install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;

# Build google test
WORKDIR /usr/src
RUN git clone https://github.com/google/googletest.git
WORKDIR /usr/src/googletest/install
RUN cmake ../ && make && make install

# Install json.h
RUN mkdir /usr/local/include/json
WORKDIR /usr/local/include/json
RUN curl -f -O -J -L https://github.com/nlohmann/json/releases/download/v3.5.0/json.hpp
RUN mv json.hpp json.h

# Install httplib
WORKDIR /tmp
RUN git clone https://github.com/klavins/cpp-httplib.git
RUN mkdir /usr/local/include/httplib
RUN mv /tmp/cpp-httplib/httplib.h /usr/local/include/httplib
RUN rm -r /tmp/cpp-httplib
EXPOSE 8080

WORKDIR /source

COPY bashrc /root/.bashrc
