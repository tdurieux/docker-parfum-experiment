ARG dist=debian
ARG flavor=sid

FROM ${dist}:${flavor} as builder


RUN apt-get update && apt-get install -y --no-install-recommends autoconf make gcc \
                     automake autotools-dev \
                     ocaml-nox camlidl coccinelle \
                     libocamlnet-ocaml-dev libocamlnet-ocaml-bin \
                     libocamlnet-ssl-ocaml libocamlnet-ssl-ocaml-dev \
                     libssl-dev gnutls-dev \
                     libconfig-file-ocaml-dev camlp4 && rm -rf /var/lib/apt/lists/*;

FROM builder
COPY . /build

WORKDIR /build

RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-idlgen --with-rpcgen --with-libnames=foo --with-ssl --with-ssl-clientfiles='env'
RUN make