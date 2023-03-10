FROM alpine:3.8 AS extract

ARG RPM_URLS

RUN apk add --no-cache curl rpm tar && true
WORKDIR /rpm
RUN mkdir extract
RUN for url in ${RPM_URLS}; do \
        echo "Extracting: $url"; \
        curl -fsSL -o dl.rpm $url && \
        rpm2cpio dl.rpm | cpio -idm ;\
    done

RUN for d in lib/modules/*; do depmod -b . $(basename $d); done

RUN mkdir /out
# With some fedora rpms, the kernel and system map are in modules directory
RUN cp -a boot/vmlinuz-* /out/kernel || mv lib/modules/*/vmlinuz /out/kernel
RUN cp -a boot/config-* /out/kernel_config || mv lib/modules/*/config /out/kernel_config
RUN cp -a boot/System.map-* /out/System.map || mv lib/modules/*/System.map /out/System.map
RUN tar cf /out/kernel.tar lib
RUN tar cf /out/kernel-dev.tar usr || true

FROM scratch
WORKDIR /
ENTRYPOINT []
CMD []
COPY --from=extract /out/* /