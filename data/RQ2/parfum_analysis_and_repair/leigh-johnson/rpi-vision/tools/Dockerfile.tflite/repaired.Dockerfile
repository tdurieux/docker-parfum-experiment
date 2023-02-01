from tensorflow/tensorflow:nightly-devel

ARG tensorflow_version=v2.0.0-beta0

RUN apt-get update && apt-get install --no-install-recommends -y crossbuild-essential-armhf && rm -rf /var/lib/apt/lists/*;

RUN /tensorflow/tensorflow/lite/tools/make/download_dependencies.sh

RUN /tensorflow/tensorflow/lite/tools/make/build_rpi_lib.sh

WORKDIR /tensorflow
CMD ['/bin/bash']
