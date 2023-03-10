FROM debian:9.6

RUN apt-get update
RUN apt-get --yes --no-install-recommends install apache2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install python && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN a2dissite 000-default

RUN a2enmod cgid
RUN a2enmod rewrite
RUN echo 'ServerName feedvalidator.org' >>/etc/apache2/apache2.conf

WORKDIR /feedvalidator

ADD . /feedvalidator
ADD sites-available-feedvalidator.conf /etc/apache2/sites-available/feedvalidator.conf

RUN a2ensite feedvalidator

EXPOSE 80

ENV HTTP_HOST https://feedvalidator.org/
ENV SCRIPT_NAME check.cgi
ENV SCRIPT_FILENAME /feedvalidator/check.cgi

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
