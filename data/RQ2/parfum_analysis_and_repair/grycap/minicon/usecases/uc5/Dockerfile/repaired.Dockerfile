FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y --force-yes apache2 && rm -rf /var/lib/apt/lists/*;
EXPOSE 80 443
VOLUME ["/var/www", "/var/log/apache2", "/etc/apache2"]
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
