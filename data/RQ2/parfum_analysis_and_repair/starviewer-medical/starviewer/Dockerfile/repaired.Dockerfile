FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN cat /etc/lsb-release
RUN apt-get -qq update
RUN apt-get install -y --no-install-recommends -qq build-essential clang libgl1-mesa-dev libglu1-mesa-dev xvfb wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends -qq qtbase5-dev libqt5x11extras5-dev libqt5xmlpatterns5-dev qtdeclarative5-dev qtwebengine5-dev qttools5-dev qt5-default && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends -qq libwrap0 libwrap0-dev zlib1g zlib1g-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*
RUN unset DEBIAN_FRONTEND

RUN wget -nv --directory-prefix=/ https://trueta.udg.edu/apt/ubuntu/devel/0.15/starviewer-sdk-linux-0.15-4.tar.xz
RUN mkdir /sdk-0.15
RUN tar xf /starviewer-sdk-linux-0.15-4.tar.xz -C /sdk-0.15 && rm /starviewer-sdk-linux-0.15-4.tar.xz

ENV SDK_INSTALL_PREFIX /sdk-0.15/usr/local
ENV LD_LIBRARY_PATH /sdk-0.15/usr/local/lib:/sdk-0.15/usr/local/lib/x86_64-linux-gnu

WORKDIR /starviewer/starviewer
CMD ["bash"]
