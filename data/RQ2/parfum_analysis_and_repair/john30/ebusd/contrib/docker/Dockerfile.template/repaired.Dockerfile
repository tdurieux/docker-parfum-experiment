ARG BASE_IMAGE

FROM $BASE_IMAGE as build

RUN apt-get update && apt-get install --no-install-recommends -y \
    libmosquitto-dev libssl-dev libstdc++6 libc6 libgcc1 \
    curl \
    autoconf automake g++ make git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

ARG TARGETARCH
ARG TARGETVARIANT
ARG EBUSD_VERSION

ENV EBUSD_ARCH $TARGETARCH$TARGETVARIANT
ENV EBUSD_VERSION $EBUSD_VERSION

ADD . /build
RUN %EBUSD_MAKE%

%EBUSD_UPLOAD_LINES%


FROM $BASE_IMAGE-slim as image

RUN apt-get update && apt-get install --no-install-recommends -y \
    libmosquitto1 libssl1.1 ca-certificates libstdc++6 libc6 libgcc1 \
    && rm -rf /var/lib/apt/lists/*

LABEL maintainer="ebusd@ebusd.eu"

ARG TARGETARCH
ARG TARGETVARIANT
ARG EBUSD_VERSION
ARG EBUSD_IMAGE

ENV EBUSD_ARCH $TARGETARCH$TARGETVARIANT
ENV EBUSD_VERSION $EBUSD_VERSION

LABEL version="${EBUSD_VERSION}-${EBUSD_ARCH}%EBUSD_VERSION_VARIANT%"

%EBUSD_COPYDEB%

RUN dpkg -i "--path-exclude=/etc/default/*" "--path-exclude=/etc/init.d/*" "--path-exclude=/lib/systemd/*" %EBUSD_DEBSRC% \
    && update-ca-certificates \
    && ebusd -V

EXPOSE 8888

%EBUSD_COPYENTRY%
ENTRYPOINT ["/docker-entrypoint.sh"]

ENV EBUSD_FOREGROUND ""
CMD ["--scanconfig"]
