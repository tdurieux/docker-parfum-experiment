FROM resin/rpi-raspbian:jessie
ENTRYPOINT []

RUN apt-get update -qy && apt-get -qy --no-install-recommends install \
  build-essential git && rm -rf /var/lib/apt/lists/*;
WORKDIR /root/
RUN git clone https://github.com/FFmpeg/FFmpeg.git
workdir /root/FFmpeg
RUN apt-get install --no-install-recommends -qy libomxil-bellagio-dev && rm -rf /var/lib/apt/lists/*;

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --arch=armel --target-os=linux --enable-gpl --enable-omx --enable-omx-rpi --enable-nonfree
RUN make
RUN make install

CMD ["/bin/bash"]
