FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/backup_mark_impermanent_test.sh"