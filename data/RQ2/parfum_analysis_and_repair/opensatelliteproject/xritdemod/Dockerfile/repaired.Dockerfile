FROM ubuntu:16.04
RUN apt-get update -y
RUN apt-get install --no-install-recommends software-properties-common locales -y && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:myriadrf/drivers -y
RUN add-apt-repository ppa:myriadrf/gnuradio -y
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y libairspy-dev libusb-1.0-0-dev libhackrf-dev libhackrf0 build-essential git cmake && rm -rf /var/lib/apt/lists/*;
RUN mkdir /builds
WORKDIR /builds
RUN git clone https://github.com/opensatelliteproject/xritdemod.git
WORKDIR /builds/xritdemod
RUN make libcorrect
RUN make libcorrect-install
RUN make libSatHelper
RUN make libSatHelper-install
RUN make librtlsdr
RUN make librtlsdr-install
RUN make
RUN make test

