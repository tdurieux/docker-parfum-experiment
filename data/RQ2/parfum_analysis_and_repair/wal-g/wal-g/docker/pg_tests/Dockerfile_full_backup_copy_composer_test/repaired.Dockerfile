FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/full_backup_copy_composer_test.sh"