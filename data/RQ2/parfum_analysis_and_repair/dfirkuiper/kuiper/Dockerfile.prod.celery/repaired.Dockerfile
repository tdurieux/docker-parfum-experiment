FROM python:2.7

RUN mkdir -p /app/
WORKDIR /app
RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf

COPY ./kuiper/requirements_3.txt ./requirements_3.txt
COPY ./kuiper/requirements_2.7.txt ./requirements_2.7.txt

RUN apt update -y && apt install --no-install-recommends -y python-minimal python3 python-dev libsasl2-dev libldap2-dev libssl-dev python-pip build-essential libssl-dev libffi-dev libxml2-dev libxslt1-dev zlib1g-dev python3-pip cron && rm -rf /var/lib/apt/lists/*;
RUN pip2 install --no-cache-dir --upgrade pip
RUN pip2 install --no-cache-dir -r "./requirements_2.7.txt"
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r "./requirements_3.txt"


COPY ./system_health/ /system_health/

COPY ./system_health/crontabs/crontab.celery /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab
RUN crontab /etc/cron.d/crontab
RUN touch /var/log/cron_celery.log


CMD cron && python -m celery worker -A app.celery_app --loglevel=info -n "kuiper@%h"
