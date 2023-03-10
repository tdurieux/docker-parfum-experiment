# Soft HSM test Docker image
#
# LinOTP can use the PKCS11 library to provide access to a
# Hardware Security Module (HSM). The hardware to be
# used is accessed using a supplied library.
#
# Given that LinOTP can be used with any supported HSM,
# the standard Docker image does not provide any specific
# libraries and the expectation is that a derived Docker
# image would be made to provide the necessary configuration
# and initialisation needed.
#
# This Docker image provides a sample implementation using the
# SoftHSM library (https://github.com/opendnssec/SoftHSMv2)
#
# Due to the design of the library implementation,
# access is limited to a single thread, and so it is not
# recommended for production use with LinOTP.

ARG SOFTHSM_BASE_IMAGE=linotp:latest
FROM $SOFTHSM_BASE_IMAGE

ENV SOFTHSM2_CONF=/etc/softhsm/softhsm2.conf \
    PKCS11_DLL=/usr/lib/softhsm/libsofthsm2.so

COPY docker-init-softhsm.sh /etc/linotp/docker-init.d/05-docker-init-softhsm

RUN apt-get update \
    && apt-get install -y --no-install-recommends softhsm2 \
    && mkdir -p /etc/softhsm /var/lib/softhsm/tokens \
    && echo "directories.tokendir = /var/lib/softhsm/tokens" > /etc/softhsm/softhsm2.conf \
    && echo "objectstore.backend = file" >> /etc/softhsm/softhsm2.conf \
    && usermod -a -G softhsm linotp \
    && chmod 755 /etc/linotp/docker-init.d/05-docker-init-softhsm && rm -rf /var/lib/apt/lists/*;

