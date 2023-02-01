FROM emscripten/emsdk:3.1.0

RUN apt-get update && \
    apt-get install --no-install-recommends -qqy autoconf automake libtool && rm -rf /var/lib/apt/lists/*;
