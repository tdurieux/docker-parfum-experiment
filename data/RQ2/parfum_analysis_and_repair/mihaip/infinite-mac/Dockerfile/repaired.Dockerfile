FROM emscripten/emsdk:2.0.31
 RUN apt update && apt install --no-install-recommends -y autoconf libsdl1.2-dev && rm -rf /var/lib/apt/lists/*;
