FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/delete_end_to_end_test.sh"