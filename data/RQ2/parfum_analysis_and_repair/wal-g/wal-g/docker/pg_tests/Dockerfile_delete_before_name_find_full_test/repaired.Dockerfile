FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/delete_before_name_find_full_test.sh"