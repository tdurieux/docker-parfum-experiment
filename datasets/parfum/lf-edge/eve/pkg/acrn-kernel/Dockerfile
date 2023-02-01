FROM lfedge/eve-alpine:6.7.0 as kernel-build

ENV BUILD_PKGS \
    argp-standalone automake bash bc binutils-dev bison build-base curl \
    diffutils flex git gmp-dev gnupg installkernel kmod libressl-dev    \
    linux-headers ncurses-dev python3 findutils sed squashfs-tools tar  \
    xz xz-dev zlib-dev openssl lz4 lz4-libs elfutils-libelf elfutils-dev
RUN eve-alpine-deploy.sh


# Download acrn-kernel
ENV KERNEL_VERSION acrn-2019w39.3-150000p
ENV KERNEL_SOURCE=https://github.com/projectacrn/acrn-kernel/archive/${KERNEL_VERSION}.tar.gz
RUN \
    [ -f "$(basename ${KERNEL_SOURCE})" ] || curl -fsSLO "${KERNEL_SOURCE}" && \
    tar --absolute-names -xz < "$(basename ${KERNEL_SOURCE})" && mv "/acrn-kernel-${KERNEL_VERSION}" /acrn-kernel
RUN ls -l /acrn-kernel

# Apply local patches
COPY patches-${KERNEL_VERSION} /patches
WORKDIR /acrn-kernel
RUN set -e && for patch in /patches/*.patch; do \
        echo "Applying $patch"; \
        patch -p1 < "$patch"; \
    done

# build acrn-kernel
RUN rm -rf /out && mkdir /out
RUN if [ "$(uname -m)" = "x86_64" ] ; then \
    cp kernel_config_uefi_sos .config && \
    make olddefconfig && \
    make -j4 && \
    cp arch/x86_64/boot/bzImage /out/kernel && \
    cp System.map /out ;\
fi

RUN echo "KERNEL_SOURCE=${KERNEL_SOURCE}" > /out/kernel-source-info

# Don't install modules for now. We should trim the config.
RUN touch /out/kernel.tar
RUN touch /out/kernel-dev.tar
# Don't install the headers for now.
RUN touch /out/kernel-headers.tar

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=kernel-build /out/* /
