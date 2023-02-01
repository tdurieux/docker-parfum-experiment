FROM ricejasonf/emscripten:1.37.39

  # cctools (linker for darwin targets)
  # https://opensource.apple.com/tarballs/Libc/Libc-1244.30.3.tar.gz
  RUN git clone https://github.com/unofficial-opensource-apple/Libc \
    && cd Libc \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/install \
    && make \
    && make install

