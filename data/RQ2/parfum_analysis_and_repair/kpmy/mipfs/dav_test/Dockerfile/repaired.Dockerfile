FROM gcc:latest
COPY . /usr/src/litmus
WORKDIR /usr/src/litmus
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make install
CMD bash
