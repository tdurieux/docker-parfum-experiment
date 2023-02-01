FROM ubuntu:rolling
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y build-essential cmake libmariadb-dev libconfig-dev syslog-ng-dev bats \
syslog-ng mariadb-client libconfig9 ruby pkg-config && rm -rf /var/lib/apt/lists/*;
