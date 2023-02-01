# CentOS 6 based container with Java installed
#

FROM centos:centos6
MAINTAINER David Nguyen <nguyen1d@us.ibm.com>

# 1)  Install RPMs needed for the rest of the setup
# 2)  Install supervisord to run our daemons
# 3)  Install Maven
# 4)  Create acmeair base directory