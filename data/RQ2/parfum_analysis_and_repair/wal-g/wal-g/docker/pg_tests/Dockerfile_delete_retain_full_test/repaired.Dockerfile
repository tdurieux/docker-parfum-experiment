FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/delete_retain_full_test.sh"