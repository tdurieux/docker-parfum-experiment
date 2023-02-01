FROM ubuntu
MAINTAINER Maluuba Infrastructure Team <infrastructure@maluuba.com>

RUN apt-get -qq update && apt-get -y --no-install-recommends install s3cmd && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq upgrade



ADD backup.sh /opt/backup.sh
ADD s3cfg /.s3cfg

RUN chmod +x /opt/backup.sh

# Run Backup script
CMD ["/opt/backup.sh"]