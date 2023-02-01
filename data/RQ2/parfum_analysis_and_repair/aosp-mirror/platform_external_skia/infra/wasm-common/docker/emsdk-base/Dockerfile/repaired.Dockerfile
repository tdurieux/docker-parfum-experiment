FROM emscripten/emsdk:2.0.10

RUN apt update && apt install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /OUT /SRC
