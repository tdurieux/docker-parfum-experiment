FROM alanfranz/fwd-centos-7:latest
MAINTAINER Alan Franzoni <username@franzoni.eu>
# whatever is required for building should be installed in this image; just like BuildRequires: for RPM specs
RUN yum -y install readline-devel && rm -rf /var/cache/yum
