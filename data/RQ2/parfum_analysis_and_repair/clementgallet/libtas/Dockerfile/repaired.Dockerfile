FROM debian:10

# update
  RUN dpkg --add-architecture i386
  RUN apt-get update

# libtas
  # dependencies
    # main
      RUN apt-get -y --no-install-recommends install build-essential automake pkg-config libx11-dev libx11-xcb-dev qtbase5-dev qt5-default libsdl2-dev libxcb1-dev libxcb-keysyms1-dev libxcb-xkb-dev libxcb-cursor-dev libxcb-randr0-dev libudev-dev libasound2-dev libavutil-dev libswresample-dev ffmpeg liblua5.3-dev && rm -rf /var/lib/apt/lists/*;

    # HUD
      RUN apt-get -y --no-install-recommends install libfreetype6-dev libfontconfig1-dev && rm -rf /var/lib/apt/lists/*;

    # fonts
      RUN apt-get -y --no-install-recommends install libfreetype6-dev libfontconfig1-dev && rm -rf /var/lib/apt/lists/*;
      RUN apt-get -y --no-install-recommends install fonts-liberation && rm -rf /var/lib/apt/lists/*;

    # i386
      RUN apt-get -y --no-install-recommends install g++-multilib && rm -rf /var/lib/apt/lists/*;
      RUN apt-get -y --no-install-recommends install libx11-6:i386 libx11-dev:i386 libx11-xcb1:i386 libx11-xcb-dev:i386 libasound2:i386 libasound2-dev:i386 libavutil56:i386 libswresample3:i386 libfreetype6:i386 libfreetype6-dev:i386 libfontconfig1:i386 libfontconfig1-dev:i386 && rm -rf /var/lib/apt/lists/*;


  # install
    RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
    RUN mkdir /root/src
    RUN cd /root/src && git clone https://github.com/clementgallet/libTAS.git
    RUN cd /root/src/libTAS && ./build.sh --with-i386
    RUN cd /root/src/libTAS && make install

# additional programs
  # wine
    RUN apt-get -y --no-install-recommends install wine && rm -rf /var/lib/apt/lists/*;

  # pcem
    # dependencies
      RUN apt-get -y --no-install-recommends install libwxbase3.0-dev libwxgtk3.0-gtk3-dev wx-common libsdl2-dev libopenal-dev && rm -rf /var/lib/apt/lists/*;

    # install
      RUN cd /root/src && git clone https://github.com/TASVideos/pcem.git
      RUN cd /root/src/pcem && git checkout v16_9b737f6
      RUN cd /root/src/pcem && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-release-build
      RUN cd /root/src/pcem && autoreconf
      RUN cd /root/src/pcem && make

# run
  CMD bash
