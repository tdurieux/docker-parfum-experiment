FROM debian:bullseye

# allow fetching source packages
RUN echo "deb-src http://deb.debian.org/debian/ bullseye main" >> /etc/apt/sources.list

# prepare
RUN apt-get update -qq

# install build essentials
RUN apt-get install --no-install-recommends -yq build-essential && rm -rf /var/lib/apt/lists/*;

# install PackageKit dependencies
RUN apt-get build-dep -yq packagekit
RUN apt-get install --no-install-recommends -yq meson && rm -rf /var/lib/apt/lists/*;

# finish
RUN mkdir /build
WORKDIR /build
