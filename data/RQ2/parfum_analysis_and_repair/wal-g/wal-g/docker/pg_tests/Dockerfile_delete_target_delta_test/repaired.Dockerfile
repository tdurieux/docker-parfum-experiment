FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/delete_target_delta_test.sh"