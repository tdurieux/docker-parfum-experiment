FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/ghost_table_test.sh"