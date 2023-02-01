# This Dockerfile builds the pikepdf wheel
# Inputs:
#    - REPO - Docker repository to pull qpdf from
#    - QPDF_VERSION - The image qpdf version to copy .deb files from
#    - PIKEPDF_GIT_TAG - The Git tag to clone and build from
#    - PIKEPDF_VERSION - Used to force the built pikepdf version to match

# Default to pulling from the main repo registry when manually building
ARG REPO="paperless-ngx/paperless-ngx"

ARG QPDF_VERSION
FROM ghcr.io/${REPO}/builder/qpdf:${QPDF_VERSION} as qpdf-builder

# This does nothing, except provide a name for a copy below

FROM python:3.9-slim-bullseye as main

LABEL org.opencontainers.image.description="A intermediate image with pikepdf wheel built"

ARG DEBIAN_FRONTEND=noninteractive

ARG BUILD_PACKAGES="\
  build-essential \
  python3-dev \
  python3-pip \
  git \
  # qpdf requirement - https://github.com/qpdf/qpdf#crypto-providers
  libgnutls28-dev \
  # lxml requrements - https://lxml.de/installation.html
  libxml2-dev \
  libxslt1-dev \
  # Pillow requirements - https://pillow.readthedocs.io/en/stable/installation.html#external-libraries
  # JPEG functionality
  libjpeg62-turbo-dev \
  # conpressed PNG
  zlib1g-dev \
  # compressed TIFF
  libtiff-dev \
  # type related services
  libfreetype-dev \
  # color management
  liblcms2-dev \
  # WebP format
  libwebp-dev \
  # JPEG 2000
  libopenjp2-7-dev \
  # improved color quantization
  libimagequant-dev \
  # complex text layout support
  libraqm-dev"

WORKDIR /usr/src

COPY --from=qpdf-builder /usr/src/qpdf/*.deb ./

# As this is an base image for a multi-stage final image
# the added size of the install is basically irrelevant

RUN set -eux \
  && apt-get update --quiet \
  && apt-get install --yes --quiet --no-install-recommends $BUILD_PACKAGES \
  && dpkg --install libqpdf28_*.deb \
  && dpkg --install libqpdf-dev_*.deb \
  && python3 -m pip install --no-cache-dir --upgrade \
    pip \
    wheel \
    # https://pikepdf.readthedocs.io/en/latest/installation.html#requirements
    pybind11 \
  && rm -rf /var/lib/apt/lists/*

# Layers after this point change according to required version
# For better caching, seperate the basic installs from
# the building

ARG PIKEPDF_GIT_TAG
ARG PIKEPDF_VERSION

RUN set -eux \
  && echo "building pikepdf wheel" \
  # Note the v in the tag name here
  && git clone --quiet --depth 1 --branch "${PIKEPDF_GIT_TAG}" https://github.com/pikepdf/pikepdf.git \
  && cd pikepdf \
  # pikepdf seems to specifciy either a next version when built OR
  # a post release tag.
  # In either case, this won't match what we want from requirements.txt
  # Directly modify the setup.py to set the version we just checked out of Git
  && sed -i "s/use_scm_version=True/version=\"${PIKEPDF_VERSION}\"/g" setup.py \
  # https://github.com/pikepdf/pikepdf/issues/323