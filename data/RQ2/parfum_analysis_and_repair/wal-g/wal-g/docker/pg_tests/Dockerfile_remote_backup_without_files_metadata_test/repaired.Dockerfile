FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/remote_backup_without_files_metadata_test.sh"