FROM tensorflow/tensorflow:devel

RUN apt-get update && apt-get install --no-install-recommends -y crossbuild-essential-arm64 && rm -rf /var/lib/apt/lists/*;
COPY linux_makefile.inc /tensorflow_src/tensorflow/lite/tools/make/targets/linux_makefile.inc
COPY disable_nnapi.patch /tensorflow_src

WORKDIR /tensorflow_src
RUN patch -p1 < disable_nnapi.patch
