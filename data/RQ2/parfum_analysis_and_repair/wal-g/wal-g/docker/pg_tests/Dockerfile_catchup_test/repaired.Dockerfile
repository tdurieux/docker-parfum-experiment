FROM wal-g/docker_prefix:latest

CMD su - postgres /tmp/tests/catchup_test.sh