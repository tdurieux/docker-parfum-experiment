FROM gcr.io/oss-fuzz-base/base-builder:v1
RUN apt-get update && apt-get install --no-install-recommends -y make autoconf automake libtool pkg-config && rm -rf /var/lib/apt/lists/*;
COPY . $SRC/nghttp3
WORKDIR nghttp3
COPY .clusterfuzzlite/build.sh $SRC/
