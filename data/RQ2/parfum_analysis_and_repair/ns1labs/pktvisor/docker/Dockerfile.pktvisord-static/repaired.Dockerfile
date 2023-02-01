FROM ns1labs/static-base AS cppbuild

FROM scratch AS runtime

COPY --from=cppbuild /tmp/build/bin/pktvisord /pktvisord

ENTRYPOINT [ "/pktvisord" ]