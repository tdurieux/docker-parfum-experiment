FROM emscripten/emsdk:3.1.3
RUN apt-get update && apt-get install --no-install-recommends -qqy autoconf autopoint pkg-config && rm -rf /var/lib/apt/lists/*;
WORKDIR /src
ENV EM_CACHE /src/deps/.emcache
CMD ["sh", "-c", "emmake make -j`nproc`"]
