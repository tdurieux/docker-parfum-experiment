FROM pandorafms/pandorafms-base:centos7
MAINTAINER Pandora FMS Team <info@pandorafms.com>

# Pandora FMS Server dependencies
RUN yum install -y fping perl-Test-WWW-Selenium perl-Crypt-Blowfish perl-Crypt-ECB perl-Crypt-Rijndael perl-Net-OpenSSH && rm -rf /var/cache/yum

RUN ln -s /usr/bin/braa /usr/local/bin/braa

