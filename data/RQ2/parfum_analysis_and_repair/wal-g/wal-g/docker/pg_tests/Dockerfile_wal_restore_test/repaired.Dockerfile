FROM wal-g/docker_prefix:latest

CMD su - postgres /tmp/tests/wal_restore_test.sh