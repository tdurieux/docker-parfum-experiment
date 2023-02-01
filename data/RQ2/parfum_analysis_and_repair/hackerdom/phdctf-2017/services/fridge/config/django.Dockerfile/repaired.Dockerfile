FROM ubuntu:latest

MAINTAINER andgein@yandex.ru

RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip uwsgi uwsgi-plugin-python3 postgresql-client && rm -rf /var/lib/apt/lists/*;

# Install application requirements
ADD ./web/requirements.txt /
RUN pip3 install --no-cache-dir -U pip
RUN pip3 install --no-cache-dir -Ur /requirements.txt

# Add code
ADD ./web /srv

# Add start script
ADD ./config/django.start.sh /
RUN chmod +x ./django.start.sh

# Add uWSGI config
ADD ./config/django.uwsgi.ini /etc/uwsgi/fridge.ini

# Add database check script
ADD ./config/db.check.py /

# Execute start script
CMD ["./django.start.sh"]