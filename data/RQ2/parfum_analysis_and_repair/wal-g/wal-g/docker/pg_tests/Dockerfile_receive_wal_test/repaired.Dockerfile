FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/receive_wal_test.sh"