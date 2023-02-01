FROM ubuntu:16.04

MAINTAINER FOSSEE <pythonsupport@fossee.in>

RUN apt-get update -y && apt-get install --no-install-recommends git python3-pip vim libmysqlclient-dev sudo -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends apache2 libapache2-mod-wsgi-py3 python3-django -y && mkdir -p /Sites/online_test && rm -rf /var/lib/apt/lists/*;

VOLUME /Sites/online_test

ADD Files/requirements-* /tmp/

RUN cd /Sites/online_test && pip3 install --no-cache-dir -r /tmp/requirements-py3.txt

ADD Files/000-default.conf /etc/apache2/sites-enabled/

ADD Files/Docker-script.sh /Sites/Docker-script.sh

EXPOSE 80

WORKDIR /Sites/online_test

CMD [ "/bin/bash" , "/Sites/Docker-script.sh" ]
