# syntax=docker/dockerfile:1.1.3-experimental

ARG SDK
FROM ${SDK} as downloadrpm
ARG ARCH
ARG PACKAGE

WORKDIR /home/builder
RUN --mount=source=./etc/yum.repos.d,target=/etc/yum.repos.d \
    --mount=source=./etc/dnf,target=/etc/dnf \
    mkdir -p ./rpmdownload; \
    dnf download --resolve --alldeps --arch ${ARCH} --forcearch ${ARCH} ${PACKAGE} || { \
        dnf download --resolve --alldeps --arch noarch --forcearch ${ARCH} ${PACKAGE}; \
    } && cp -a *.rpm ./rpmdownload/;

FROM scratch AS tencentrpm
COPY --from=downloadrpm /home/builder/rpmdownload/*.rpm /output/
