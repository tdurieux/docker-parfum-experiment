FROM emscripten/emsdk:3.1.15

# Enable detection of running in a container
ENV RUNNING_IN_CONTAINER=true

RUN apt-get update \
  && apt-get install --no-install-recommends -qqy \
    build-essential \
    autoconf \
    libtool \
    pkgconf \
    libglib2.0-dev \
    # needed for building libvips from source
    gtk-doc-tools \
    gobject-introspection \
    # needed for Meson
    ninja-build \
    python3-pip \
  && pip3 install --no-cache-dir meson && rm -rf /var/lib/apt/lists/*;

ARG MESON_PATCH=https://github.com/kleisauke/wasm-vips/raw/master/build/patches/meson-emscripten.patch
RUN cd $(dirname `python3 -c "import mesonbuild as _; print(_.__path__[0])"`) \
  && curl -f -Ls $MESON_PATCH | patch -p1
