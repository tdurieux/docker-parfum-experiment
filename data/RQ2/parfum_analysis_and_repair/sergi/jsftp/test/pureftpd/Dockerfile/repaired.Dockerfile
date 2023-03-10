FROM debian:jessie

# feel free to change this ;)
MAINTAINER Andrew Stilliard <andrew.stilliard@gmail.com>

# properly setup debian sources
ENV DEBIAN_FRONTEND noninteractive
RUN echo "deb http://http.debian.net/debian jessie main\n\
deb-src http://http.debian.net/debian jessie main\n\
deb http://http.debian.net/debian jessie-updates main\n\
deb-src http://http.debian.net/debian jessie-updates main\n\
deb http://security.debian.org jessie/updates main\n\
deb-src http://security.debian.org jessie/updates main\n\
" > /etc/apt/sources.list
RUN apt-get -y update

# install package building helpers
RUN apt-get -y --no-install-recommends --force-yes --fix-missing install dpkg-dev debhelper && rm -rf /var/lib/apt/lists/*;

# install dependancies
RUN apt-get -y build-dep pure-ftpd

# build from source
RUN mkdir /tmp/pure-ftpd/ && \
	cd /tmp/pure-ftpd/ && \
	apt-get source pure-ftpd && \
	cd pure-ftpd-* && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-tls && \
	sed -i '/^optflags=/ s/$/ --without-capabilities/g' ./debian/rules && \
	dpkg-buildpackage -b -uc

# install the new deb files
RUN dpkg -i /tmp/pure-ftpd/pure-ftpd-common*.deb
RUN apt-get -y --no-install-recommends install openbsd-inetd && rm -rf /var/lib/apt/lists/*;
RUN dpkg -i /tmp/pure-ftpd/pure-ftpd_*.deb

# Prevent pure-ftpd upgrading
RUN apt-mark hold pure-ftpd pure-ftpd-common

# setup ftpgroup and ftpuser
RUN groupadd ftpgroup
RUN useradd -g ftpgroup -d /home/ftpusers -s /dev/null ftpuser

RUN mkdir -p /home/ftpusers/bob/fixtures
COPY ./fixtures /home/ftpusers/bob/fixtures
RUN chown -R ftpuser:ftpgroup /home/ftpusers && chmod 744 /home/ftpusers

# rsyslog for logging (ref https://github.com/stilliard/docker-pure-ftpd/issues/17)
RUN apt-get install --no-install-recommends -y rsyslog && \
	echo "" >> /etc/rsyslog.conf && \
	echo "#PureFTP Custom Logging" >> /etc/rsyslog.conf && \
	echo "ftp.* /var/log/pure-ftpd/pureftpd.log" >> /etc/rsyslog.conf && \
	echo "Updated /etc/rsyslog.conf with /var/log/pure-ftpd/pureftpd.log" && rm -rf /var/lib/apt/lists/*;

# setup run/init file
COPY run.sh /run.sh
RUN chmod u+x /run.sh

# default publichost, you'll need to set this for passive support
ENV PUBLICHOST localhost

# couple available volumes you may want to use
VOLUME ["/home/ftpusers", "/etc/pure-ftpd/passwd"]

# startup
CMD /run.sh -c 5 -C 5 -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R -P $PUBLICHOST -p 30000:30009

EXPOSE 21 30000-30009
