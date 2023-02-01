FROM gcr.io/oss-fuzz-base/base-builder:v1
RUN apt-get update && apt-get install --no-install-recommends -y make libssl-dev libbsd-dev && rm -rf /var/lib/apt/lists/*;
COPY . $SRC/app-stellar
WORKDIR $SRC/app-stellar
COPY .clusterfuzzlite/build.sh $SRC/
