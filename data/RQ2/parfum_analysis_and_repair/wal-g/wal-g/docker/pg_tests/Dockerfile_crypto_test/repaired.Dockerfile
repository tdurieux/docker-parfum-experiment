FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/crypto_test.sh"