FROM nemirtingas/osxcross_vcpkg:SDK10.15
RUN apt-get install --no-install-recommends -y ninja-build genisoimage zlib1g-dev && rm -rf /var/lib/apt/lists/*;
ENV MACOSX_DEPLOYMENT_TARGET=10.9
ENV OSXCROSS_MACPORTS_MIRROR=http://packages.macports.org
RUN osxcross-macports install libsdl2
WORKDIR /build
COPY SDL2.patch .
RUN patch /osxcross/target/macports/pkgs/opt/local/lib/cmake/SDL2/sdl2-config.cmake SDL2.patch
ADD https://github.com/djdron/UnrealSpeccyP/releases/download/angle-chromium84/angle-chromium89.tar.xz .
ADD https://github.com/djdron/UnrealSpeccyP/releases/download/angle-chromium84/dmg-template.tar.xz .
RUN git clone https://github.com/fanquake/libdmg-hfsplus.git && \
    cd libdmg-hfsplus && mkdir build && cd build && cmake .. && cmake --build . -- -j 4
COPY build.sh .
ENTRYPOINT ./build.sh
