FROM silkeh/clang:10

ENV PISA_SRC="/pisa"
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

ENV TOOLCHAIN="-DCMAKE_TOOLCHAIN_FILE=clang.cmake"

WORKDIR $PISA_SRC

RUN apt-get update -y && apt-get install --no-install-recommends -y cmake libtool && rm -rf /var/lib/apt/lists/*;
