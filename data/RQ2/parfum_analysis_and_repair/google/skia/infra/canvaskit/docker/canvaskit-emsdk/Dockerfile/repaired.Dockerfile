# A Docker image that augments the Emscripten SDK Docker image
# with anything needed to build CanvasKit

FROM gcr.io/skia-public/emsdk-base:3.1.3_v1

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
  libfreetype6-dev && rm -rf /var/lib/apt/lists/*;
