FROM archlinux

RUN pacman -Sy --noconfirm --needed \
    git base-devel gcc python python-pip make openssl iputils
RUN pacman -Sy --noconfirm --needed \
    curl libcurl-compat apr apr-util nghttp2 pcre jansson rsync

RUN pacman -Sy --noconfirm --needed apache

RUN pip install pytest tqdm pycurl cryptography requests

COPY docker/archlinux/bin/* /apache-httpd/bin/
COPY configure.ac Makefile.am NEWS README* AUTHORS ChangeLog COPYING LICENSE /apache-httpd/mod_h2/
COPY m4 /apache-httpd/mod_h2/m4
COPY mod_http2 /apache-httpd/mod_h2/mod_http2
COPY test test/Makefile.am /apache-httpd/mod_h2/test/
COPY test/pyhttpd /apache-httpd/mod_h2/test/pyhttpd
COPY test/modules /apache-httpd/mod_h2/test/modules
COPY test/unit /apache-httpd/mod_h2/test/unit

CMD ["/bin/bash", "-c", "/apache-httpd/bin/mod_h2_test.sh"]