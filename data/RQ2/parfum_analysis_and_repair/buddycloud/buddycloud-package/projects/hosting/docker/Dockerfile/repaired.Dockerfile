# Ubuntu/precise is the main distribution
FROM ubuntu:precise

# add python
RUN rm -rvf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl1.0.0 openssl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-setuptools python-dev postgresql-server-dev-9.1 libsqlite3-dev python dbconfig-common build-essential && rm -rf /var/lib/apt/lists/*;
<<<<<<< HEAD
RUN apt-get install --no-install-recommends -y python-sqlalchemy && rm -rf /var/lib/apt/lists/*;

ADD hosting.deb /tmp/hosting.deb
RUN /bin/echo v1
RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/hosting.deb
ADD buddycloud-hosting.cfg /usr/share/buddycloud-hosting/hosting.cfg

ENTRYPOINT cd /usr/share/buddycloud-hosting; env; python run.py > /var/log/hosting/hosting.log 2>&1
=======
RUN apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

# add logstash sources list and install it
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget -O - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
RUN echo 'deb http://packages.elasticsearch.org/logstashforwarder/debian stable main' | tee /etc/apt/sources.list.d/logstash.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y logstash-forwarder && rm -rf /var/lib/apt/lists/*;

# add logstash conf
ADD logstash.conf /tmp/logstash.conf

# create hosting XMPP account
ADD create-hosting-account.sh /tmp/create-hosting-account.sh
RUN bash /tmp/create-hosting-account.sh

# install the hosting package
ADD hosting.deb /tmp/hosting.deb
RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/hosting.deb
ADD buddycloud-hosting.cfg /usr/share/buddycloud-hosting/hosting.cfg
ADD logging.cfg /usr/share/buddycloud-hosting/logging.cfg

ENTRYPOINT ln -s /srv/secret/logstash-forwarder.crt /opt/logstash-forwarder/logstash-forwarder.crt; ln -s /srv/secret/logstash-forwarder.key /opt/logstash-forwarder/logstash-forwarder.key; /opt/logstash-forwarder/bin/logstash-forwarder -config /tmp/logstash.conf & cd /usr/share/buddycloud-hosting; python run.py
>>>>>>> f7f2029bf9c65699c35e2d32ffe21d70422844cb
EXPOSE 3000
