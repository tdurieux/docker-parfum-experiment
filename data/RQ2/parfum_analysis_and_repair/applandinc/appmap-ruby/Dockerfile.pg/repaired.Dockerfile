FROM postgres:10

HEALTHCHECK --interval=1s --retries=10 CMD psql -U postgres -c "select 1" || exit 1