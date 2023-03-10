FROM debian:jessie
MAINTAINER Medici.Yan@Gmail.com
# RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends -y psmisc cron python python-pip \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir flask gunicorn supervisor==3.3.2 \
    && mkdir -p /htdocs/templates && rm -rf /var/lib/apt/lists/*;

COPY src/app.py /htdocs/app.py
COPY src/index.html /htdocs/templates/index.html
COPY src/supervisor.conf /etc/supervisor.conf
COPY src/start.sh /start.sh
COPY src/daemon.sh /daemon.sh
COPY src/root /var/spool/cron/crontabs/root

RUN chmod a+x /start.sh /daemon.sh \
    && rm -rf /var/lib/apt/lists

CMD ["/start.sh"]
