# To build, cd to this directory, then:
#   docker build -t rstudio/shinycoreci:sso-4.2-bionic .
#   docker build --build-arg EXTRA_BASE_TAG="-rc_v1.4.0.1" -t rstudio/shinycoreci:sso-4.2-bionic-rc_v1.4.0.1 .
#
# To run:
#   docker run --rm -p 3838:3838 --name sso_bionic rstudio/shinycoreci:sso-4.2-bionic

ARG R_VERSION=4.2
ARG RELEASE=focal
ARG EXTRA_BASE_TAG=
FROM ghcr.io/rstudio/shinycoreci:base-${R_VERSION}-${RELEASE}${EXTRA_BASE_TAG}

ARG R_VERSION=4.2
ARG RELEASE=focal
ARG EXTRA_BASE_TAG=

# =====================================================================
# Shiny Server
# =====================================================================

# Download and install shiny server