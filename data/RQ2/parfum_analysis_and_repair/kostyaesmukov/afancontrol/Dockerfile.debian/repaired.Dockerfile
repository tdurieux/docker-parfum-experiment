# Docker image for building an `afancontrol` package for Debian.

FROM debian:unstable

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        build-essential \
        debhelper \
        devscripts \
        python3 \
        vim-tiny && rm -rf /var/lib/apt/lists/*;

# https://github.com/inversepath/usbarmory-debian-base_image/issues/9#issuecomment-451635505
RUN mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf

# Import the GPG key used to sign the PyPI releases of `afancontrol`:
RUN gpg --batch --recv-keys "AA7B5406547AF062"

COPY debian /build/afancontrol/debian
WORKDIR /build/afancontrol/

RUN mkdir -p debian/upstream \
    && gpg --batch --export --export-options export-minimal --armor \
        'A18FE9F6F570D5B4E1E1853FAA7B5406547AF062' \
        > debian/upstream/signing-key.asc

RUN apt-get -y build-dep .
