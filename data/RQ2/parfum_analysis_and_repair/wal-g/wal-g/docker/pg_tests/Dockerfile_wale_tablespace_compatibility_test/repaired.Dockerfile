FROM wal-g/docker_prefix:latest

CMD su postgres -c "/tmp/tests/wale_tablespace_compatibility_test.sh"