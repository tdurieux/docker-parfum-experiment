FROM emscripten/emsdk:3.1.3

RUN apt update && apt install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /OUT /SRC
