FROM wal-g/docker_prefix:latest

CMD su - postgres /tmp/tests/archiving_ready_rename.sh