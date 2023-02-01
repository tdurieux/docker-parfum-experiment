FROM postgres:12
RUN apt-get update && apt-get install --no-install-recommends -y dos2unix && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq python-pip python-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq cron && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir awscli
COPY pg_dump-to-s3 /home
RUN chmod +x /home/pg_dump-to-s3.sh /home/s3-autodelete.sh
RUN crontab /home/backup.txt
RUN service cron start
RUN dos2unix /home/pg_dump-to-s3.sh
RUN dos2unix /home/s3-autodelete.sh
