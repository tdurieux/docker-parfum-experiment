FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/full_backup_rating_composer_test.sh"