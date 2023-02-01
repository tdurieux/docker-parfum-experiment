FROM deadbeef-builder-player-clang-14.04-distro

RUN apt-get -qq update && apt-get install --no-install-recommends -y -qq libgtk-3-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/deadbeef
COPY . /usr/src/deadbeef

RUN rm -rf m4
RUN rm ltmain.sh
RUN ./autogen.sh
RUN CC=clang ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN CC=clang make distcheck

