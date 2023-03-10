# Build Ubuntu image
FROM @BUILD_ARCH@/@BUILD_FLAVOR@:@BUILD_RELEASE@

# see https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#/run
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  @BUILD_PACKAGES@ \
  build-essential \
  g++ && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
