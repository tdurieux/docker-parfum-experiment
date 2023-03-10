FROM ubuntu:bionic

COPY ./sdk_container.sh /
COPY ./build_wasm.sh /
COPY *.cc *.h *.js *.proto Makefile* *.a /sdk/

RUN ./sdk_container.sh