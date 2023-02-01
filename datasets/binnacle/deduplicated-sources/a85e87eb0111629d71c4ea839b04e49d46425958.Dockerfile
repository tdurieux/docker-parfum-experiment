FROM trzeci/emscripten:sdk-incoming-64bit
MAINTAINER Joel Martin <github@martintribe.org>

RUN apt-get update && \
    apt-get -y install git-core cmake g++

## Download and build binaryen into emscripten ports/cache
#RUN rm -r /root/.emscripten_cache* && \
#    echo "int main() {}" > /tmp/nop.c && \
#    emcc -s BINARYEN=1 /tmp/nop.c -o /tmp/nop.js && \
#    rm /tmp/nop.c /tmp/nop.js

RUN git clone https://github.com/WebAssembly/binaryen/ && \
    cd binaryen && \
    git checkout version_14 && \
    cmake . && make && \
    make install

RUN echo 'BINARYEN_ROOT="/usr/local"' >> /root/.emscripten && \
    echo 'RELOCATABLE=""' >> /root/.emscripten && \
    rm -r /root/.emscripten_cache* && \
    echo "int main() {}" > /tmp/nop.c && \
    emcc -s BINARYEN=1 /tmp/nop.c -o /tmp/nop.js && \
    rm /tmp/nop*


# Version 0x0d:
#   c5ab566cc3343d3b9e07eab4855b0dbfb2c81afe
#   Oct 26, 2016

# --mem-base
#   c8eccc4ceb1d538fc394578c23ba87bb50835b3f
#   Oct 31, 2016
