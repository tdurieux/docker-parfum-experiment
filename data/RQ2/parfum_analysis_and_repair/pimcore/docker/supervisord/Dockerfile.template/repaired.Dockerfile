FROM pimcore/pimcore:PHP%%PHP_TAG%%-cli
RUN apt-get update && apt-get install --no-install-recommends -y supervisor cron && rm -rf /var/lib/apt/lists/*;
COPY supervisord.conf /etc/supervisor/supervisord.conf

RUN chmod gu+rw /var/run
RUN chmod gu+s /usr/sbin/cron

CMD ["/usr/bin/supervisord"]