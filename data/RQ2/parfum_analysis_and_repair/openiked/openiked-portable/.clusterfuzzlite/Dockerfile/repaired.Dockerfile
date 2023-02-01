FROM gcr.io/oss-fuzz-base/base-builder:v1
RUN apt-get update && apt-get install --no-install-recommends -y bison libssl-dev libevent-dev && rm -rf /var/lib/apt/lists/*;
COPY . $SRC/openiked-portable
WORKDIR openiked-portable
COPY .clusterfuzzlite/build.sh $SRC/
