FROM ricejasonf/parmexpr as build

  RUN apt-get update -yq && apt-get install --no-install-recommends -yq wget && rm -rf /var/lib/apt/lists/*;

  WORKDIR /opt/src
  RUN wget https://ftp.postgresql.org/pub/source/v12.1/postgresql-12.1.tar.gz \
   && tar -xvzf postgresql-12.1.tar.gz && rm postgresql-12.1.tar.gz

  WORKDIR /opt/src/postgresql-12.1
  RUN mkdir /opt/install \
   && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix /opt/install \
                  --without-readline \
                  --without-zlib \
   && make \
   && make -C src/include install \
   && make -C src/interfaces install

FROM ubuntu:eoan
  COPY --from=build /opt/install /opt/install
