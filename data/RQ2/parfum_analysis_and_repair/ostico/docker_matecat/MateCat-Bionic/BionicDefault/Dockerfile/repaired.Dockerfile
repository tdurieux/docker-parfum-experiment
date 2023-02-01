FROM ubuntu:bionic

RUN apt-get update && apt-get -y --no-install-recommends --fix-missing install ssh-client vim locate iputils-ping monit git curl wget net-tools tree software-properties-common locales \
    psmisc screen dstat \
    traceroute whois libaio1 perl perl-base perl-modules && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y full-upgrade