ARG dist=debian
ARG flavor=sid

FROM ${dist}:${flavor} as builder


RUN apt-get update && apt-get install -y --no-install-recommends autoconf make gcc \
                     automake autotools-dev \
                     ocaml-nox camlidl coccinelle \
                     libocamlnet-ocaml-dev libocamlnet-ocaml-bin \
                     libocamlnet-ssl-ocaml libocamlnet-ssl-ocaml-dev \
                     libssl-dev gnutls-dev \
                     libconfig-file-ocaml-dev camlp4 \
                     opensc libtool pkg-config unzip g++ wget && rm -rf /var/lib/apt/lists/*;

WORKDIR /softhsm
RUN wget --no-check-certificate https://github.com/opendnssec/SoftHSMv2/archive/refs/tags/2.6.1.zip && unzip 2.6.1.zip

WORKDIR /softhsm/SoftHSMv2-2.6.1
RUN ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

FROM builder
COPY . /build

WORKDIR /build

RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-idlgen --with-rpcgen --with-libnames=foo
RUN make
RUN make install

RUN softhsm2-util --init-token --slot 0 --label caml-crush-int-tests --pin 1234 --so-pin 123456

ENTRYPOINT [ "/build/src/tests/integration/run-tests.sh" ]