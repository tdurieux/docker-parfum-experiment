FROM python:2-jessie
RUN apt-get -qq update && apt-get -qq --no-install-recommends install -y \
      cron \
      mysql-client \
      rsync && rm -rf /var/lib/apt/lists/*;

ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY backup-cron /etc/cron.d/
RUN chmod 0644 /etc/cron.d/backup-cron

COPY run_cron.sh run_backup.sh backup_to_dropbox.py requirements.txt /root/
WORKDIR /root
RUN pip install --no-cache-dir -r requirements.txt

VOLUME /var/log

CMD ["./run_cron.sh"]
