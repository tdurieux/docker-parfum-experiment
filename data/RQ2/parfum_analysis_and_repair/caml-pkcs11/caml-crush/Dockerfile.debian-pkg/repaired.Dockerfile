ARG dist=debian
ARG flavor=sid

FROM ${dist}:${flavor} as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y --no-install-recommends autoconf make gcc \
                     automake autotools-dev \
                     ocaml-nox camlidl coccinelle \
                     libocamlnet-ocaml-dev libocamlnet-ocaml-bin \
                     libocamlnet-ssl-ocaml libocamlnet-ssl-ocaml-dev \
                     libssl-dev gnutls-dev \
                     libconfig-file-ocaml-dev camlp4 \
                     git-buildpackage debhelper \
                     dh-exec dh-autoreconf build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends ca-certificates fakeroot debhelper && rm -rf /var/lib/apt/lists/*;

FROM builder

WORKDIR /build/git
COPY . .

RUN mkdir /tmp/output
