FROM emscripten/emsdk
RUN apt update && apt install --no-install-recommends -y autoconf && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["bash", "-c", "cd encoder && ./configure && make"]