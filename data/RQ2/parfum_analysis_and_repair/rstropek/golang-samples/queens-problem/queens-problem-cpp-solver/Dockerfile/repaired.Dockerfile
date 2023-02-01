# Use a multi-stage build
FROM trzeci/emscripten:latest AS builder

# Compile CPP into WASM
WORKDIR /app
COPY ./*.cpp ./
RUN emcc qps.cpp -I/usr/include/x86_64-linux-gnu/c++/6/ -O3 -Wno-c++11-extensions -o qpcpp.js

FROM nginx:alpine

# Copy exe from build container