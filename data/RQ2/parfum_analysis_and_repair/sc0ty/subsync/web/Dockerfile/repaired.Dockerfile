FROM trzeci/emscripten

RUN apt-get update && \
    apt-get install --no-install-recommends -qqy automake libtool bison pkg-config && rm -rf /var/lib/apt/lists/*;
