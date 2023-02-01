FROM debian
RUN apt-get -yqq update && apt-get install --no-install-recommends -yqq supervisor apache2 && rm -rf /var/lib/apt/lists/*;
RUN a2enmod rewrite
RUN a2enmod cgi
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf
ADD supervisord.conf /etc/supervisor/conf.d/
CMD ["supervisord"]
