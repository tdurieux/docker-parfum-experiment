# This Source Code Form is licensed MPL-2.0: http://mozilla.org/MPL/2.0

# == Distribution preparation ==
FROM ubuntu:bionic
ENV DEBIAN_FRONTEND noninteractive

# Use BASH(1) as shell, affects the RUN commands below
RUN ln -sf bash /bin/sh && ls -al /bin/sh

# Keep all steps + cleanups in one layer to reduce the resulting size
RUN \

  echo '## Provide /bin/retry' && \
  echo -e '#!/bin/bash\n"$@" || { sleep 15 ; "$@" ; } || { sleep 90 ; "$@" ; }' > /bin/retry && chmod +x /bin/retry && \
  \
  echo '## Avoid unused documentation' && \
  mkdir mkdir  /etc/dpkg/dpkg.conf.d && \
  echo -e > /etc/dpkg/dpkg.conf.d/01_nodoc \
       'path-exclude=/usr/share/locale/*\npath-exclude=/usr/share/man/*\npath-exclude=/usr/share/info/*\npath-exclude=/usr/share/groff/*\n' \
       'path-exclude=/usr/share/lintian/*\npath-exclude=/usr/share/doc/*\npath-include=/usr/share/doc/*/copyright\n' && \
  \
  echo '## Upgrade packages' && \
  retry apt-get update && retry apt-get -y install eatmydata && \
  retry eatmydata apt-get -y upgrade && \
  \
  echo '## Build stripped down fluidsynth version without drivers' && \
  retry eatmydata apt-get install -y build-essential curl cmake libglib2.0-dev && \
  mkdir -p /tmp/fluid/build && cd /tmp/fluid/ && \
  curl -sfSOL https://github.com/FluidSynth/fluidsynth/archive/v2.0.9.tar.gz && \
  tar xf v2.0.9.tar.gz && rm v2.0.9.tar.gz && cd build && \
  cmake ../fluidsynth-2.0.9 \
	-DCMAKE_INSTALL_PREFIX=/usr/ \
	-DLIB_SUFFIX="/`dpkg-architecture -qDEB_HOST_MULTIARCH`" \
	-Denable-libsndfile=1 \
	-Denable-dbus=0 \
	-Denable-ipv6=0 \
	-Denable-jack=0 \
	-Denable-midishare=0 \
	-Denable-network=0 \
	-Denable-oss=0 \
	-Denable-pulseaudio=0 \
	-Denable-readline=0 \
	-Denable-alsa=0 \
	-Denable-lash=0 && \
  make && make install && cd / && rm -rf /tmp/fluid/ && \
  eatmydata apt-get --purge remove -y cmake && \
  \
  echo '## Provide Beast dependencies, add libXss.so for electron' && \
  V=9 && \
  retry eatmydata apt-get install -y \
	build-essential automake autoconf autoconf-archive libtool \
	curl doxygen graphviz texlive-binaries git libxml2-utils g++-8 \
	libxml2-dev gawk python2.7-dev python3 libboost-system-dev \
	cppcheck clang-$V clang-tidy-$V clang-tools-$V python3-pandocfilters \
	libasound2-dev libflac-dev libvorbis-dev libmad0-dev libjack-dev \
	gettext imagemagick libgconf-2-4 nodejs unzip libxss1 \
	libgtk-3-bin libgdk-pixbuf2.0-dev && \
  update-alternatives \
    --install /usr/bin/gcc                 gcc                 /usr/bin/gcc-8 900 \
    --slave   /usr/bin/g++                 g++                 /usr/bin/g++-8 && \
  update-alternatives \
    --install /usr/bin/clang               clang               /usr/bin/clang-$V 900 \
    --slave   /usr/bin/asan_symbolize      asan_symbolize      /usr/bin/asan_symbolize-$V \
    --slave   /usr/bin/clang++             clang++             /usr/bin/clang++-$V  \
    --slave   /usr/bin/clang-check         clang-check         /usr/bin/clang-check-$V \
    --slave   /usr/bin/clang-cpp           clang-cpp           /usr/bin/clang-cpp-$V \
    --slave   /usr/bin/clang-tidy          clang-tidy          /usr/bin/clang-tidy-$V \
    --slave   /usr/bin/scan-build          scan-build          /usr/bin/scan-build-$V && \

  curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && \
  apt-get install --no-install-recommends -y nodejs && \

  echo '## Provide recent Pandoc' && \
  retry curl -ROL 'https://github.com/jgm/pandoc/releases/download/2.9/pandoc-2.9-1-amd64.deb' && \
  dpkg -i pandoc-2.9-1-amd64.deb && \
  rm pandoc-2.9-1-amd64.deb && \

  echo '## Cleanup' && \
  eatmydata apt-get --purge remove -y cmake python2.7-dev && \
  eatmydata apt-get autoremove -y && \
  apt-get clean && rm -rf /var/lib/apt/lists/* && \
  find /usr/share/locale/ -mindepth 1 -maxdepth 1 ! -name 'en*' | xargs rm -r && \
  find /usr/share/doc/ -depth -type f ! -name copyright | xargs rm -f && \
  rm -rf /usr/share/man/* /usr/share/groff/* /usr/share/info/* /usr/share/lintian/* && \
  :
