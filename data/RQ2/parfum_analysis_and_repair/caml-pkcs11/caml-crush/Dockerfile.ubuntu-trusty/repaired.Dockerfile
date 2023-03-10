FROM ubuntu:trusty as builder


RUN apt-get update && apt-get install -y --no-install-recommends autoconf make gcc \
                     automake autotools-dev \
                     ocaml-nox camlidl coccinelle libocamlnet-ocaml-dev \
                     libocamlnet-ssl-ocaml libocamlnet-ssl-ocaml-dev \
                     libocamlnet-ocaml-bin libconfig-file-ocaml-dev camlp4 \
                     libssl-dev libgnutls-dev ca-certificates pkg-config \
                     ocaml-findlib wget && rm -rf /var/lib/apt/lists/*;

FROM builder
COPY . /build

WORKDIR /build

# install findlib
RUN wget https://download.camlcity.org/download/findlib-1.5.6.tar.gz -O /tmp/findlib-1.5.6.tar.gz
RUN cd /tmp && tar xzf findlib-1.5.6.tar.gz && cd findlib-1.5.6 && \
        ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" -config /etc/ocamlfind.conf -bindir /usr/bin/ \
             -sitelib /usr/lib/ocaml -with-toolbox && \
        make all && make opt && sudo make install && rm findlib-1.5.6.tar.gz

# install ocaml-ssl
RUN wget https://github.com/savonet/ocaml-ssl/releases/download/0.5.5/ocaml-ssl-0.5.5.tar.gz -O /tmp/ocaml-ssl-0.5.5.tar.gz
RUN cd /tmp && tar xzf /tmp/ocaml-ssl-0.5.5.tar.gz && cd ocaml-ssl-0.5.5 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && sudo make install && rm /tmp/ocaml-ssl-0.5.5.tar.gz

RUN cd /build

RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-idlgen --with-rpcgen --with-libnames=foo
RUN make