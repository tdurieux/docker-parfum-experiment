FROM scratch

COPY ./bin/nfproxy /nfproxy
ENTRYPOINT ["/nfproxy"]