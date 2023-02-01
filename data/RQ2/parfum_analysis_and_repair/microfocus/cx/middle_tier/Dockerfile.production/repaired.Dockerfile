FROM ubuntu:16.04
WORKDIR /opt/middle_tier

RUN apt-get update && apt-get install --no-install-recommends -qy \
    build-essential python3-dev supervisor && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -qy virtualenv && rm -rf /var/lib/apt/lists/*;
RUN virtualenv -p /usr/bin/python3.5 /opt/penv

RUN . /opt/penv/bin/activate && pip install --no-cache-dir uwsgi
COPY cx/middle_tier/requirements.txt /opt/middle_tier
RUN . /opt/penv/bin/activate && pip3 install --no-cache-dir -r requirements.txt

COPY cx/middle_tier /opt/middle_tier

RUN chown -R www-data:www-data /opt/middle_tier


COPY conf/supervisor-app.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80
CMD ["supervisord", "-n"]
