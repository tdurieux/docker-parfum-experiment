#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM python:3.6
MAINTAINER Tim Sutton<tim@kartoza.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl
#RUN  ln -s /bin/true /sbin/initctl

RUN apt-get -y update && apt-get -y --no-install-recommends install osm2pgsql && rm -rf /var/lib/apt/lists/*;

ADD requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

ADD reporter /reporter

ADD server.py /server.py

# Open port 8080 so linked containers can see them
EXPOSE 8080

CMD ["python", "server.py"]
