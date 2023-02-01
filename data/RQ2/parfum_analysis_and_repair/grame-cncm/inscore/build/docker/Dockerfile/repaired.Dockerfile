FROM ubuntu:bionic

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y libmicrohttpd-dev libpulse-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libqt5svg5-dev libqt5websockets5-dev libqt5sensors5-dev qtmultimedia5-dev qtdeclarative5-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake git libcairo2-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /grame
RUN git clone --single-branch -b dev --depth 1 https://github.com/grame-cncm/inscore.git
WORKDIR /grame/inscore/build
RUN make modules -j 4
RUN make -C ../modules/guidolib/build install
RUN make -C ../modules/libmusicxml/build install
RUN mkdir inscoredir
RUN make inscore -j 4
