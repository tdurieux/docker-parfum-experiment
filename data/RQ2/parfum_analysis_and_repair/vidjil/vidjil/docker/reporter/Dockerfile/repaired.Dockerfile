from vidjil/server:test

run apt-get clean && rm -rf /var/lib/apt/lists/* && apt-get update && apt-get install --no-install-recommends -y cron python python-pip iputils-ping && rm -rf /var/lib/apt/lists/*;

run pip install --no-cache-dir crontab requests

add crontab /etc/cron.d/reporter

run chmod 0644 /etc/cron.d/reporter

run touch /var/log/cron.log

cmd cron && tail -f /var/log/cron.log
