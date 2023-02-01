FROM postgres:12.3
LABEL "Product"="PostgreSQL (SSL enabled)"
COPY server.key /var/lib/postgresql/server.key
COPY server.crt /var/lib/postgresql/server.crt
RUN chown postgres /var/lib/postgresql/server.key && \
    chmod 600 /var/lib/postgresql/server.key
