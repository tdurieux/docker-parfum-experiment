FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/wale_compatibility_test.sh"