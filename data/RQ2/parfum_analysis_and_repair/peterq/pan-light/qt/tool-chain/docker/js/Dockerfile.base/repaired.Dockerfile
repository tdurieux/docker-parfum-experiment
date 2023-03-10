FROM ubuntu:16.04
LABEL maintainer therecipe

ENV USER user
ENV HOME /home/$USER

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install build-essential git && rm -rf /var/lib/apt/lists/*;

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install python2.7 nodejs cmake default-jre && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/python2.7 /usr/bin/python
RUN git clone -q --depth 1 https://github.com/juj/emsdk.git $HOME/emsdk && cd $HOME/emsdk && ./emsdk install latest && ./emsdk activate latest

RUN git clone -q --depth 1 -b 5.12.0 --recursive https://code.qt.io/qt/qt5.git /opt/qt5

RUN echo "#!/bin/bash\nsource $HOME/emsdk/emsdk_env.sh \
	&& cd /opt/qt5 && ./configure -xplatform wasm-emscripten -optimize-size -nomake tests -nomake examples -skip qtpim -skip qtfeedback -skip qtwinextras -skip qttools -confirm-license -opensource && make && make install" > $HOME/build.sh \
	&& chmod +x $HOME/build.sh && $HOME/build.sh
