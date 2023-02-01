FROM debian:wheezy

RUN apt-get update && apt-get -y upgrade

RUN apt-get install --no-install-recommends -y libdist-zilla-perl dpkg-dev devscripts apache2 libapache2-mod-perl2 libnet-ldap-perl libfile-cache-perl libwww-perl perl-modules libcrypt-ssleay-perl && rm -rf /var/lib/apt/lists/*;

ADD build.sh /build.sh

CMD sh /build.sh