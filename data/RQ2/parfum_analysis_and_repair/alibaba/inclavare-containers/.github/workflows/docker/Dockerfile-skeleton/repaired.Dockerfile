FROM scratch

COPY encl.bin /
COPY encl.ss /
ENTRYPOINT ["dummy"]