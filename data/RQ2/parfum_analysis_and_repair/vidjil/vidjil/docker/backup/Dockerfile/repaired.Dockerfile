FROM vidjil/server:latest

RUN apt-get update && apt-get install --no-install-recommends -y mysql-client zip && rm -rf /var/lib/apt/lists/*;

RUN touch /var/log/cron.log

RUN ln -sf /etc/backup/backup-cron /etc/cron.d/backup-cron

RUN ln -sf /etc/backup/backup.cnf /root/.my.cnf

RUN ln -sf /dev/stdout /var/log/cron.log && ln -sf /dev/stderr /var/log/cron.log

CMD cron && tail -f /var/log/cron.log
