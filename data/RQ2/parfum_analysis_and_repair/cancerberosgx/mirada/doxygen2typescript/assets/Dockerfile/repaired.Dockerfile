# docker build platforms/js -t opencv.js
# docker run --rm --workdir /code -v "$PWD":/code opencv.js  python ./platforms/js/build_js.py build_wasm --build_wasm --build_doc

FROM trzeci/emscripten:latest

RUN apt-get update -y && apt-get install --no-install-recommends -y doxygen && rm -rf /var/lib/apt/lists/*;