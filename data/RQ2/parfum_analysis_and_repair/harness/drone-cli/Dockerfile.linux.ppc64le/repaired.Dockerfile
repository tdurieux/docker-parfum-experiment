FROM drone/ca-certs

COPY release/linux/ppc64le/drone /bin/

ENTRYPOINT ["/bin/drone"]