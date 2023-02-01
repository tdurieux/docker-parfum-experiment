#There are four parts:
# a) building tpm2-tss
# b) building tpm2-tools
# c) building the vtpm server from local source
# d) extracting only required bits from tpm2-tss and tpm2-tools
#    and the server

#Build TPM2-TSS and TPM2-TOOLS
FROM lfedge/eve-alpine:6.7.0 as build
ENV BUILD_PKGS linux-headers git gcc g++ autoconf automake libtool doxygen make \
               openssl-dev protobuf-dev gnupg curl-dev patch
ENV PKGS alpine-baselayout musl-utils
RUN eve-alpine-deploy.sh

WORKDIR /
RUN wget https://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2019.01.06.tar.xz && \
    wget https://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2019.01.06.tar.xz.sig && \
    gpg2 -q --keyserver keyserver.ubuntu.com --recv-keys 99089D72 && \
    gpg2 -q --verify autoconf-archive-2019.01.06.tar.xz.sig

#Build autoconf-archive
RUN tar -xvf autoconf-archive-2019.01.06.tar.xz
WORKDIR /autoconf-archive-2019.01.06
RUN ./configure --datarootdir=/usr/share/ && \
    make && make install

WORKDIR /
RUN git clone --branch=2.3.1 https://github.com/tpm2-software/tpm2-tss
WORKDIR /tpm2-tss
RUN ./bootstrap && \
    ./configure --disable-dependency-tracking && \
    make && \
    make install

WORKDIR /
RUN git clone --branch=4.0.1-rc0 https://github.com/tpm2-software/tpm2-tools
WORKDIR /tpm2-tools
COPY patch-tpm2-tools.diff .
RUN patch -p1 < patch-tpm2-tools.diff && \
    ./bootstrap && ./configure && make

RUN mkdir -p /out/usr/local/lib
RUN cp lib/.libs/libcommon.so* /out/usr/local/lib/
RUN cp tools/.libs/tpm2_* /out/usr/bin/

#The vTPM server
COPY ./ /vtpm_server
WORKDIR /vtpm_server
RUN make && cp vtpm_server /out/usr/bin/

# install dependencies
WORKDIR /usr/lib
RUN cp libstdc++.so.6 libgcc_s.so.1 libprotobuf.so.24.0.0 /out/usr/lib/
RUN ln -s libprotobuf.so.24.0.0 /out/usr/lib/libprotobuf.so.24
WORKDIR /usr/local/lib
RUN cp libtss2-tctildr.so.0 libtss2-rc.so.0 libtss2-mu.so.0 libtss2-esys.so.0 \
       libtss2-sys.so.0.0.0 libtss2-sys.so.0 libtss2-tcti-device.so.0 /out/usr/local/lib/

#Pull a selected set of artifacts into the final stage.
FROM scratch

COPY --from=build /out/ /
COPY init.sh /usr/bin/
ENTRYPOINT []
WORKDIR /
CMD ["/usr/bin/init.sh"]
