FROM emscripten/emsdk
RUN apt-get update && apt-get -y --no-install-recommends install libgl-dev libogg-dev libsdl2-dev python3 && rm -rf /var/lib/apt/lists/*;