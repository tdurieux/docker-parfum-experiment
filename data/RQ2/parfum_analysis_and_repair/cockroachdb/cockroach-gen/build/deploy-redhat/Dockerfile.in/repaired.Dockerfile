FROM @repository@:@tag@

LABEL name="CockroachDB"
LABEL vendor="Cockroach Labs"
LABEL summary="CockroachDB is a distributed SQL database."
LABEL description="CockroachDB is a PostgreSQL wire-compatable distributed SQL database."

ENV COCKROACH_CHANNEL=official-openshift