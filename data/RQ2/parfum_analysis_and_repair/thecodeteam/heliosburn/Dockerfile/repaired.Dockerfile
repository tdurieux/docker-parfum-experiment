FROM ubuntu:latest

ADD requirements.txt /tmp/requirements.txt
ADD heliosburn /opt/HeliosBurn/heliosburn
# Clone the conf files into the docker container
# Will have to do once HB is public, currently need a key and a release
# RUN git clone git@github.com:emccode/HeliosBurn.git
ADD heliosburn/django/hbproject/example.env /opt/HeliosBurn/heliosburn/django/hbproject/.env
ADD install/docker/modules.yaml /opt/HeliosBurn/heliosburn/proxy/modules.yaml
ADD install/docker/config.yaml /opt/HeliosBurn/heliosburn/proxy/config.yaml
ADD install/docker/settings.py /opt/HeliosBurn/heliosburn/django/hbproject/hbproject/settings.py
ADD install/docker/proxy_settings.py /opt/HeliosBurn/heliosburn/proxy/settings.py

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ipython-notebook && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install npm && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install supervisor && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install default-jre && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install openssl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libyaml-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libpython2.7-dev && rm -rf /var/lib/apt/lists/*;
RUN sed -i "s/DJANGO_SECRET_KEY.*/DJANGO_SECRET_KEY="'$(openssl rand -hex 16)'"/" /opt/HeliosBurn/heliosburn/django/hbproject/.env
#Temporary, should pull out of hblog.py
RUN sed -i "s/redis_host = 'loc.*/redis_host="\'redis\'"/" /opt/HeliosBurn/heliosburn/hblog/hblog.py
RUN sed -i "s/mongodb_host = 'loc.*/mongodb_host="\'mongo\'"/" /opt/HeliosBurn/heliosburn/hblog/hblog.py
RUN pip install --no-cache-dir -r /tmp/requirements.txt
ADD install/etc/supervisor/conf.d/*.conf /etc/supervisor/conf.d/
#RUN python /opt/HeliosBurn/heliosburn/django/hbproject/create_db_model.py
EXPOSE 80
CMD ["/usr/bin/supervisord", "-n"]
