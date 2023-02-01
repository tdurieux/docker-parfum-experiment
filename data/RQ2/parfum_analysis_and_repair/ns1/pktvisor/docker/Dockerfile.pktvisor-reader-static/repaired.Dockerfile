FROM ns1labs/static-base AS cppbuild

FROM scratch AS runtime

COPY --from=cppbuild /tmp/build/bin/pktvisor-reader /pktvisor-reader

ENTRYPOINT [ "/pktvisor-reader" ]