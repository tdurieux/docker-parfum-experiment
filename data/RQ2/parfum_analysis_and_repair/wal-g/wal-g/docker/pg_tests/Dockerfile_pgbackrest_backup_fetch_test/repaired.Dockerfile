FROM wal-g/docker_pgbackrest:latest

CMD su postgres -c "/tmp/tests/pgbackrest_backup_fetch_test.sh"