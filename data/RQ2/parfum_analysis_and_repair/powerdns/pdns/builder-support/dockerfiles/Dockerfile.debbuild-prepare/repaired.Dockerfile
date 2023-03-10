FROM dist-base as package-builder
ARG APT_URL
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install devscripts dpkg-dev build-essential python3-venv equivs && rm -rf /var/lib/apt/lists/*;

RUN mkdir /dist /pdns
WORKDIR /pdns

ADD builder/helpers/ /pdns/builder/helpers/

# Used for -p option to only build specific packages
ARG BUILDER_PACKAGE_MATCH

ARG BUILDER_VERSION
ARG BUILDER_RELEASE

COPY --from=sdist /sdist /sdist

@IF [ -n "$M_authoritative$M_all" ]
RUN tar xvf /sdist/pdns-${BUILDER_VERSION}.tar.bz2 && rm /sdist/pdns-${BUILDER_VERSION}.tar.bz2
@ENDIF

@IF [ -n "$M_recursor$M_all" ]
RUN tar xvf /sdist/pdns-recursor-${BUILDER_VERSION}.tar.bz2 && rm /sdist/pdns-recursor-${BUILDER_VERSION}.tar.bz2
@ENDIF

@IF [ -n "$M_dnsdist$M_all" ]
RUN tar xvf /sdist/dnsdist-${BUILDER_VERSION}.tar.bz2 && rm /sdist/dnsdist-${BUILDER_VERSION}.tar.bz2
@ENDIF
