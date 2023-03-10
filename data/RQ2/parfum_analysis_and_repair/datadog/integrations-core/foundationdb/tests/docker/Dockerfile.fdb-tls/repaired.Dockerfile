FROM foundationdb/foundationdb:6.3.13
WORKDIR /var/fdb/tmp
COPY fdb.bash /var/fdb/scripts/fdb-new.bash
COPY tls/cert.crt /var/fdb/cert.crt
COPY tls/fdb.pem /var/fdb/fdb.pem
COPY tls/private.key /var/fdb/private.key
ENTRYPOINT ["/bin/sh", "-c", "/var/fdb/scripts/fdb-new.bash"]