ARG HHVM_BASE_IMAGE
FROM ${HHVM_BASE_IMAGE}

RUN mkdir -p /var/www/public

ADD server.ini /etc/hhvm/server.ini
RUN touch /etc/hhvm/site.ini

EXPOSE 80

CMD ["/usr/bin/hhvm", "-m", "server", "-c", "/etc/hhvm/server.ini", "-c", "/etc/hhvm/site.ini"]
