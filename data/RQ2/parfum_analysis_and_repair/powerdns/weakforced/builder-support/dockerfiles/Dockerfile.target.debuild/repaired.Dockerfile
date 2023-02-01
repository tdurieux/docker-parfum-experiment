FROM dist-base as package-builder
ARG APT_URL
RUN apt-get -y --no-install-recommends install devscripts dpkg-dev build-essential && rm -rf /var/lib/apt/lists/*;

RUN mkdir /dist /wforce
WORKDIR /wforce

ADD builder/helpers/ /wforce/builder/helpers/

# Used for -p option to only build specific spec files
ARG BUILDER_PACKAGE_MATCH

ARG BUILDER_VERSION
ARG BUILDER_RELEASE

COPY --from=sdist /sdist /sdist

@IF [ ! -z "$M_all$M_wforce" ]
RUN tar xvf /sdist/wforce-${BUILDER_VERSION}.tar.bz2 && rm /sdist/wforce-${BUILDER_VERSION}.tar.bz2
COPY builder-support/debian wforce-${BUILDER_VERSION}/debian
RUN builder/helpers/build-debs.sh wforce-$BUILDER_VERSION
@ENDIF

RUN mv dstore*${BUILDER_VERSION}*.deb /dist
