FROM fedora:latest
RUN dnf install -y gcc g++ make cmake mariadb-connector-c mariadb-connector-c-devel \
libconfig libconfig-devel syslog-ng syslog-ng-devel bats mariadb ruby pkg-config