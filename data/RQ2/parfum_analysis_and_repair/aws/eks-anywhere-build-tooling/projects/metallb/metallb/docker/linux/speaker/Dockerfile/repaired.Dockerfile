ARG BASE_IMAGE
FROM $BASE_IMAGE

ARG TARGETARCH
ARG TARGETOS

COPY _output/bin/metallb/$TARGETOS-$TARGETARCH/speaker /opt/metallb/speaker

COPY _output/LICENSES /LICENSES
COPY ATTRIBUTION.txt /ATTRIBUTION.txt


ENTRYPOINT ["/opt/metallb/speaker"]