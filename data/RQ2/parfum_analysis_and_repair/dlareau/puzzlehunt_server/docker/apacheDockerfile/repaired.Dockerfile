FROM debian:10

RUN apt-get update && \
    apt-get install --no-install-recommends -y apache2 libapache2-mod-xsendfile && rm -rf /var/lib/apt/lists/*;

COPY configs/puzzlehunt_apache.conf /etc/apache2/sites-available/puzzlehunt.conf
RUN rm /etc/apache2/sites-enabled/* && \
    a2enmod proxy proxy_http proxy_html xsendfile && \
    a2ensite puzzlehunt && \
    mkdir -p /static && \
    mkdir -p /media

EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2ctl"]
CMD ["-D", "FOREGROUND"]