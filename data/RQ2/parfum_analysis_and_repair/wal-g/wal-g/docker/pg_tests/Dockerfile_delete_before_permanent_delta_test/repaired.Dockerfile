FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/delete_before_permanent_delta_test.sh"