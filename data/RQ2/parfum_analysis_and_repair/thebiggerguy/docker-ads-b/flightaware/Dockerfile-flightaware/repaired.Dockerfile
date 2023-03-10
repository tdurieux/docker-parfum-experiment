# In general this should mirror the "sensible-build.sh" from
# https://github.com/flightaware/piaware_builder/releases

# base ########################################################################
FROM multiarch/debian-debootstrap:armhf-buster-slim as base

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        curl ca-certificates \
        net-tools iproute2 \
        tclx8.4 tcl8.6 tcllib tcl-tls itcl3 \
        python3 \
        procps && \
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# base ########################################################################
FROM base as builder-base
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y --no-install-recommends make autoconf gcc libc6-dev && rm -rf /var/lib/apt/lists/*;


# tcllauncher #################################################################
FROM builder-base as tcllauncher

ARG TCLLAUNCHER_VERSION
ARG TCLLAUNCHER_HASH

RUN apt-get install -y --no-install-recommends tcl8.6-dev && rm -rf /var/lib/apt/lists/*;

# TODO: Fix curl/Travis/GitHub SLL failure. The SHA256 checks will maintain security until this is fixed.
RUN curl -f -k --location --output tcllauncher.tar.gz "https://github.com/flightaware/tcllauncher/archive/${TCLLAUNCHER_VERSION}.tar.gz" && \
    sha256sum tcllauncher.tar.gz && echo "${TCLLAUNCHER_HASH}  tcllauncher.tar.gz" | sha256sum -c
RUN mkdir tcllauncher && cd tcllauncher && \
    tar -xvf ../tcllauncher.tar.gz --strip-components=1 && rm ../tcllauncher.tar.gz
WORKDIR tcllauncher
RUN autoconf
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix='/opt/tcl'
RUN make
RUN make install


# faup1090 ####################################################################
FROM builder-base as faup1090

ARG FAUP1090_VERSION
ARG FAUP1090_HASH

# TODO: Fix curl/Travis/GitHub SLL failure. The SHA256 checks will maintain security until this is fixed.
RUN curl -f -k --location --output faup1090.tar.gz "https://github.com/flightaware/dump1090/archive/${FAUP1090_VERSION}.tar.gz" && \
    sha256sum faup1090.tar.gz && echo "${FAUP1090_HASH}  faup1090.tar.gz" | sha256sum -c
RUN mkdir faup1090 && cd faup1090 && \
    tar -xvf ../faup1090.tar.gz --strip-components=1 && rm ../faup1090.tar.gz
WORKDIR faup1090
RUN make RTLSDR=no BLADERF=no DUMP1090_VERSION="piaware-adsb-docker" faup1090


# fa-mlat-client ##############################################################
FROM builder-base as fa-mlat-client

RUN apt-get install -y --no-install-recommends python3-dev python3-pip python3-setuptools && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade shiv importlib-resources==0.8

ARG MLAT_CLIENT_VERSION
ARG MLAT_CLIENT_HASH

# TODO: Fix curl/Travis/GitHub SLL failure. The SHA256 checks will maintain security until this is fixed.
RUN curl -f -k --location --output mlat-client.tar.gz "https://github.com/TheBiggerGuy/mlat-client/archive/${MLAT_CLIENT_VERSION}.tar.gz" && \
    sha256sum mlat-client.tar.gz && echo "${MLAT_CLIENT_HASH}  mlat-client.tar.gz" | sha256sum -c
RUN shiv --python='/usr/bin/env python3' -c fa-mlat-client -o /usr/local/bin/fa-mlat-client /mlat-client.tar.gz
RUN head -n 1 /usr/local/bin/fa-mlat-client

# piaware #####################################################################
FROM builder-base as piaware

#COPY --from=tcllauncher /usr/lib/Tcllauncher1.6/tcllauncher.tcl /usr/lib/Tcllauncher1.6/tcllauncher.tcl
#COPY --from=tcllauncher /usr/lib/Tcllauncher1.6/tcllauncher-support.tcl /usr/lib/Tcllauncher1.6/tcllauncher-support.tcl
# TODO: Version number from TCLLAUNCHER_VERSION
COPY --from=tcllauncher /usr/lib/Tcllauncher1.8 /usr/lib/Tcllauncher1.8
COPY --from=tcllauncher /usr/bin/tcllauncher /usr/bin/tcllauncher
COPY --from=tcllauncher /opt/tcl /opt/tcl

ARG PIAWARE_VERSION
ARG PIAWARE_HASH

# TODO: Fix curl/Travis/GitHub SLL failure. The SHA256 checks will maintain security until this is fixed.
RUN curl -f -k --location --output piaware.tar.gz "https://github.com/flightaware/piaware/archive/${PIAWARE_VERSION}.tar.gz" && \
    sha256sum piaware.tar.gz && echo "${PIAWARE_HASH}  piaware.tar.gz" | sha256sum -c
RUN mkdir piaware && cd piaware && \
    tar -xvf ../piaware.tar.gz --strip-components=1 && rm ../piaware.tar.gz
WORKDIR piaware
RUN make install

RUN ls /usr/lib/pi* /usr/bin/pi*


# final image #################################################################
FROM base

COPY --from=tcllauncher /usr/lib/Tcllauncher1.8 /usr/lib/Tcllauncher1.8

COPY --from=piaware /usr/bin/piaware /usr/bin/piaware
COPY --from=piaware /usr/lib/piaware /usr/lib/piaware

COPY --from=piaware /usr/bin/piaware-config /usr/bin/piaware-config
COPY --from=piaware /usr/lib/piaware-config /usr/lib/piaware-config

COPY --from=piaware /usr/bin/piaware-status /usr/bin/piaware-status
COPY --from=piaware /usr/lib/piaware-status /usr/lib/piaware-status

#COPY --from=piaware /usr/bin/pirehose /usr/bin/pirehose
#COPY --from=piaware /usr/lib/pirehose /usr/lib/pirehose

COPY --from=piaware /usr/lib/piaware_packages /usr/lib/piaware_packages
COPY --from=piaware /usr/lib/fa_adept_codec /usr/lib/fa_adept_codec

COPY --from=faup1090 /faup1090/faup1090 /usr/lib/piaware/helpers/faup1090

COPY --from=fa-mlat-client /usr/local/bin/fa-mlat-client /usr/lib/piaware/helpers/fa-mlat-client

COPY piaware.conf /etc/piaware.conf
COPY piaware-runner.sh /usr/bin/piaware-runner

EXPOSE 30105/tcp

HEALTHCHECK --start-period=1m --interval=30s --timeout=5s --retries=3 CMD piaware-status | grep -F 'piaware is connected to FlightAware.' > /dev/null; if [ 0 != $? ]; then exit 1; fi;

ENTRYPOINT ["piaware-runner"]

# Metadata
ARG VCS_REF="Unknown"
LABEL maintainer="thebigguy.co.uk@gmail.com" \
      org.label-schema.name="Docker ADS-B - flightaware" \
      org.label-schema.description="Docker container for ADS-B - This is the flightaware.com component" \
      org.label-schema.url="https://github.com/TheBiggerGuy/docker-ads-b" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.vcs-url="https://github.com/TheBiggerGuy/docker-ads-b" \
      org.label-schema.schema-version="1.0"
