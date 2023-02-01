FROM stackbrew/ubuntu:12.04
MAINTAINER Matt Bentley <mbentley@mbentley.net>
RUN (echo "deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse" > /etc/apt/sources.list && echo "deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb http://archive.ubuntu.com/ubuntu/ precise-backports main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb http://archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse" >> /etc/apt/sources.list)
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y build-essential git python python-dev python-setuptools nginx sqlite3 supervisor && rm -rf /var/lib/apt/lists/*;
RUN easy_install pip
RUN pip install --no-cache-dir uwsgi

ADD . /opt/django/

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /opt/django/django.conf /etc/nginx/sites-enabled/
RUN ln -s /opt/django/supervisord.conf /etc/supervisor/conf.d/

RUN pip install --no-cache-dir -r /opt/django/app/requirements.txt

VOLUME ["/opt/django/app"]
EXPOSE 80
CMD ["/opt/django/run.sh"]
