FROM gcc

COPY . /src/osmctools/
WORKDIR /src/osmctools/

RUN autoreconf --install
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make install
