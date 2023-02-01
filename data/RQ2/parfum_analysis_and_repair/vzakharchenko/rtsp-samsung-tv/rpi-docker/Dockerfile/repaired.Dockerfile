FROM debian:stable
MAINTAINER Vasyl Zakharchenko <vaszakharchenko@gmail.com>
LABEL author="Vasyl Zakharchenko"
LABEL email="vaszakharchenko@gmail.com"
LABEL name="rtsp-samsung-tv RaspberryPi optimization"
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y gnupg2 ca-certificates lsb-release wget && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates --fresh
RUN apt-get purge curl
RUN wget -qO-  https://deb.nodesource.com/setup_14.x | bash
RUN apt-get update && apt-get install --no-install-recommends -y nodejs curl && rm -rf /var/lib/apt/lists/*;
RUN npm i pm2 -g && npm cache clean --force;
COPY /opt/vc /opt/vc
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
      autoconf \
      automake \
      build-essential \
      cmake \
      git-core \
      libass-dev \
      libfreetype6-dev \
      libgnutls28-dev \
      libsdl2-dev \
      libtool \
      libva-dev \
      libvdpau-dev \
      libvorbis-dev \
      libxcb1-dev \
      libxcb-shm0-dev \
      libxcb-xfixes0-dev \
      pkg-config \
      texinfo \
      wget \
      yasm \
      zlib1g-de && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/FFmpeg/FFmpeg /opt/FFmpeg
#RUN cd FFmpeg && git checkout origin/release/3.2
RUN cd /opt/FFmpeg && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --arch=armel --target-os=linux --enable-libx264 --enable-gpl --enable-mmal --enable-omx --enable-omx-rpi --enable-libfdk-aac --enable-nonfree
RUN  cd /opt/FFmpeg && make -j4
RUN  cd /opt/FFmpeg && make install

# Bundle APP files
RUN npm i rtsp-samsung-tv -g && npm cache clean --force;

# Install app dependencies
ENV NPM_CONFIG_LOGLEVEL warn
COPY entrypoint.sh /opt/entrypoint.sh
RUN  chmod +x /opt/entrypoint.sh
EXPOSE 3004
ENTRYPOINT ["/opt/entrypoint.sh"]
#CMD [ "pm2-runtime", "start", "pm2.json" ]
