FROM debian:buster

RUN apt update && apt upgrade -y && apt install --no-install-recommends -y --force-yes python3-pip libpq-dev locales locales-all cron make ruby ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install sass
RUN pip3 install --no-cache-dir uwsgi

COPY requirements.txt /
RUN pip3 install --no-cache-dir -r /requirements.txt && rm /requirements.txt

# French ENV for date
RUN sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LC_ALL fr_FR
ENV LANG fr_FR
ENV LANGUAGE fr_FR

RUN mkdir /srv/app /srv/static /srv/media

WORKDIR /srv/app

COPY manage.py .
COPY static/img/ openrepairplatform/static/img/
COPY deployment/django/uwsgi.ini .
COPY deployment/django/start.sh /
COPY openrepairplatform ./openrepairplatform
COPY deployment/django/openrepairplatform.cron /etc/cron.d/openrepairplatform

RUN chmod 0644 /etc/cron.d/openrepairplatform
RUN cron
RUN useradd openrepairplatform

EXPOSE 8000

CMD /start.sh
