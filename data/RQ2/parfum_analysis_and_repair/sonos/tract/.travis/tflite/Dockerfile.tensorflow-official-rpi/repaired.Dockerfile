FROM tensorflow/tensorflow:nightly-devel

RUN apt-get update && apt-get -y --no-install-recommends install git crossbuild-essential-armhf && rm -rf /var/lib/apt/lists/*;

WORKDIR /tensorflow
RUN ./tensorflow/lite/tools/make/download_dependencies.sh


