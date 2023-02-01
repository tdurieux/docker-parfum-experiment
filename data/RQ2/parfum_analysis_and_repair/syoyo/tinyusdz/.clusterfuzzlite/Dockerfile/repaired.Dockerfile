FROM gcr.io/oss-fuzz-base/base-builder:v1
RUN apt-get update && apt-get install --no-install-recommends -y make autoconf automake libtool meson ninja-build && rm -rf /var/lib/apt/lists/*;
COPY . $SRC/tinyusdz
WORKDIR $SRC/tinyusdz
COPY .clusterfuzzlite/build.sh $SRC/
