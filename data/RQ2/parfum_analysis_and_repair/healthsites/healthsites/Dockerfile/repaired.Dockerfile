#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
# Note this base image is based on debian
FROM kartoza/django-base
MAINTAINER Tim Sutton<tim@kartoza.com>
WORKDIR /home/web/django_project

#RUN  ln -s /bin/true /sbin/initctl

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
# Or comment this line out if you do not with to use caching
#ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

RUN apt-get -y update && apt-get -y --no-install-recommends install libpq5 yui-compressor vim && rm -rf /var/lib/apt/lists/*; #-------------Application Specific Stuff ----------------------------------------------------



ADD deployment/docker/REQUIREMENTS.txt ./
ADD deployment/docker/REQUIREMENTS-dev.txt ./
RUN pip install --no-cache-dir -r REQUIREMENTS.txt -r
RUN pip install --no-cache-dir uwsgi

# Open port 49360 as we will be running our uwsgi socket on that
EXPOSE 49360

ADD ./deployment/docker/rpl-1.5.5.egg-info /usr/lib/pymodules/python2.7/

# You could put --protocol=http as a parameter (to test it directly)
# when running e.g. docker run konektaz/healthsites --protocol=http
# or any other wsgi parameters and they will be tagged on to the
# the end of the entrypoint.

# Under normal usage you would supply no additional params and
# use nginx on the host to forward in the traffic.
ADD django_project/ ./
CMD ["uwsgi", "--ini", "/uwsgi.conf"]
