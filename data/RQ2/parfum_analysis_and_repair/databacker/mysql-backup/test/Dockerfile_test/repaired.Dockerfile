# mysql backup image
ARG BASE=mysqlbackup_backup_test
FROM ${BASE}
MAINTAINER Avi Deitcher <https://github.com/deitch>

# set us up to run as non-root user
# user/group 'appuser' are created in the base