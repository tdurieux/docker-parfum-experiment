FROM library/debian:jessie
RUN apt-get update && apt-get -y --no-install-recommends install g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake libgtest-dev && rm -rf /var/lib/apt/lists/*;
RUN cd /usr/src/gtest && \
        cmake CMakeLists.txt && \
        make && \
        cp *.a /usr/lib
# by default, target source code will be at /floop/
# on the target device run environment
CMD ["bash", "-c", "/floop/test.sh"]
