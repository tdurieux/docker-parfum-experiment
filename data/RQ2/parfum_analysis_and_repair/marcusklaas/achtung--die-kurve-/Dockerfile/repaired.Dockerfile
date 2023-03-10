FROM gcc:latest
WORKDIR /usr/src/achtung
COPY . .
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && libtoolize && aclocal && make clean && make && make install
WORKDIR /usr/src/achtung/server
CMD ["./kurveserver", "-p", "80"]