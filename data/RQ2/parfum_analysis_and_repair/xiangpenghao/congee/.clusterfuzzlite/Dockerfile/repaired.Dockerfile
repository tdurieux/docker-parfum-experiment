FROM gcr.io/oss-fuzz-base/base-builder-rust:v1
RUN apt-get update && apt-get install --no-install-recommends -y make autoconf automake libtool && rm -rf /var/lib/apt/lists/*;
COPY . $SRC/congee
WORKDIR congee
COPY .clusterfuzzlite/build.sh $SRC/
