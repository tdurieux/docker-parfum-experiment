FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/delta_backup_fullscan_test.sh"