FROM wal-g/docker_prefix:latest

COPY docker/pg_tests/scripts/ /

CMD su postgres -c "/tmp/tests/several_delta_backups_reverse_test.sh"