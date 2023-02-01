FROM ufaldsg/cloud-asr-base

MAINTAINER Ondrej Klejch

RUN apt-get update && apt-get install --no-install-recommends -y libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir flask==0.10.1 flask-socketio==0.6.0 flask-sqlalchemy==2.1 MySQL-python==1.2.5 Werkzeug==0.9.6

ADD . /opt/app
WORKDIR /opt/app
CMD while true; do python run.py; done
