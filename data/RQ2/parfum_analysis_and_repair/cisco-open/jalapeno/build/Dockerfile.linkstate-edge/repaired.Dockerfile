FROM scratch

COPY ./bin/linkstate-edge /linkstate-edge
ENTRYPOINT ["/linkstate-edge"]