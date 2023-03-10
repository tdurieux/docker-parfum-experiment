FROM tensorflow/tensorflow:nightly-devel

RUN apt-get update && apt-get -yy --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

WORKDIR /tensorflow
RUN ./tensorflow/lite/tools/make/download_dependencies.sh

RUN git clone https://github.com/raspberrypi/tools /raspitools
ENV PATH=/raspitools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin:$PATH

