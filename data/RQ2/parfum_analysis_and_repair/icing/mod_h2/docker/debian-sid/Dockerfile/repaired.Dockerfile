FROM debian:sid

RUN apt-get update; apt-get upgrade -y
RUN apt-get install --no-install-recommends -y apt-listchanges \
      make openssl libssl-dev libcurl4 libcurl4-openssl-dev \
      gcc subversion git cargo python3 iputils-ping \
      libapr1-dev libaprutil1-dev libnghttp2-dev pip \
      autoconf libtool libtool-bin libpcre3-dev libjansson-dev curl rsync nghttp2-client && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pytest tqdm pycurl cryptography requests

RUN apt-get install --no-install-recommends -y apache2 apache2-dev libapache2-mod-md && rm -rf /var/lib/apt/lists/*;

COPY docker/debian-sid/bin/* /apache-httpd/bin/
COPY configure.ac Makefile.am NEWS README* AUTHORS ChangeLog COPYING LICENSE /apache-httpd/mod_h2/
COPY m4 /apache-httpd/mod_h2/m4
COPY mod_http2 /apache-httpd/mod_h2/mod_http2
COPY test test/Makefile.am /apache-httpd/mod_h2/test/
COPY test/pyhttpd /apache-httpd/mod_h2/test/pyhttpd
COPY test/modules /apache-httpd/mod_h2/test/modules
COPY test/unit /apache-httpd/mod_h2/test/unit

CMD ["/bin/bash", "-c", "/apache-httpd/bin/mod_h2_test.sh"]