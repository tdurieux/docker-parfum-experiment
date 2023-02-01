FROM mysql:5.5

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

WORKDIR /docker-entrypoint-initdb.d

# The mysql image has a one-time initdb script that checks
# for sql or script files in /docker-entrypoint-initdb.d

RUN curl -f "https://raw.githubusercontent.com/jenca-cloud/bimportal-php/master/db_dumps/empty_portal.sql" > dump.sql

# MySQL port not exposed.  Web container connects via default network (internal)


