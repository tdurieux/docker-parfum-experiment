FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/delete_without_confirm_test.sh"