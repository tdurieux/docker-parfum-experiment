FROM XENTOOLS_TAG as xentools
FROM QREXECLIB_TAG as qrexec_lib
FROM alpine:3.6 as build

RUN apk add --no-cache \
    gcc \
    make \
    libc-dev \
    linux-headers \
    git

COPY --from=xentools / /
COPY --from=qrexec_lib / /

RUN git clone https://github.com/Zededa/qubes-core-admin-linux /qubes-core-admin-linux

RUN mkdir -p /out/usr/bin

WORKDIR /qubes-core-admin-linux/qrexec

RUN make BACKEND_VMM=xen
RUN cp qrexec-daemon qrexec-client /out/usr/bin

FROM scratch
ENTRYPOINT []
CMD []
COPY --from=build /out /