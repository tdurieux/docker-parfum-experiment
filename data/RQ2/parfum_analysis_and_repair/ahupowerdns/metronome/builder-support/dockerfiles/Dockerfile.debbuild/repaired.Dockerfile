ARG BUILDER_CACHE_BUSTER=
ARG APT_URL
RUN apt-get update && apt-get -y dist-upgrade && \
      apt-get -y --no-install-recommends install devscripts dpkg-dev build-essential python3 equivs && rm -rf /var/lib/apt/lists/*;

RUN mkdir /dist /metronome
ADD builder/helpers/ /metronome/builder/helpers/
WORKDIR /metronome

# Used for -p option to only build specific packages
ARG BUILDER_PACKAGE_MATCH

ARG BUILDER_VERSION
ARG BUILDER_RELEASE
COPY --from=sdist /sdist /sdist
RUN tar xvf /sdist/metronome-${BUILDER_VERSION}.tar.bz2 && rm /sdist/metronome-${BUILDER_VERSION}.tar.bz2
ADD builder-support/debian/ metronome-${BUILDER_VERSION}/debian/
RUN builder/helpers/build-debs.sh metronome-${BUILDER_VERSION}
RUN mv metronome*.deb /dist; mv metronome*.ddeb /dist || true
