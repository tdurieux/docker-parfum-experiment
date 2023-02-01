FROM mdillon/postgis:10

# The base image already has 'postgis.sh' under /docker-entrypoint-initdb.d/.
# Since the initialization files will be executed in sorted name order,
# we name our init script such that it's processed after 'postgis.sh'.
COPY postgis-init-db.sh /docker-entrypoint-initdb.d/

# Modify pg_hba.conf and pg_ident.conf.
# Note: handled as a script (and not via RUN command in the docker file)
# so /var/lib/postgresql/data/ already exists by the time the logic is run.
COPY postgis-pg_hba.sh /docker-entrypoint-initdb.d/
