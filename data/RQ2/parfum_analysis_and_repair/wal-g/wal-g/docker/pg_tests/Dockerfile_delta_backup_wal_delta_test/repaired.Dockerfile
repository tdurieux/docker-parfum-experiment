FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/delta_backup_wal_delta_test.sh"