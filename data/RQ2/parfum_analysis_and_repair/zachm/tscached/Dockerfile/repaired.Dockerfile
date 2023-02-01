FROM ubuntu:trusty
MAINTAINER Zach Musgrave <ztm@zachm.us>

RUN apt-get update
RUN apt-get install --no-install-recommends -y git make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python2.7 python2.7-dev python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libyaml-dev libpcre3-dev && rm -rf /var/lib/apt/lists/*;

ADD . /
RUN pip install --no-cache-dir -Ur requirements.txt
RUN make frontend

CMD uwsgi --ini tscached.uwsgi.ini --wsgi-file tscached/uwsgi.py

EXPOSE 8008
