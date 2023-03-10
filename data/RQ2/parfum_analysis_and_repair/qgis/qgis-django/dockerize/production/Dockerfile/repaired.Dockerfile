#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
# Note this base image is based on debian
FROM kartoza/django-base:3.7
MAINTAINER Dimas Ciputra<dimas@kartoza.com>

#RUN  ln -s /bin/true /sbin/initctl
RUN apt-get clean all
RUN apt-get update && apt-get install --no-install-recommends -y libsasl2-dev python-dev libldap2-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

ARG BRANCH_TAG=develop
RUN mkdir -p /usr/src; rm -rf /usr/src mkdir -p /home/web && \
            git clone --depth=1 git://github.com/qgis/QGIS-Django.git --branch ${BRANCH_TAG} /usr/src/plugins/ && \
            rm -rf /home/web/django_project && \
	        ln -s /usr/src/plugins/qgis-app /home/web/django_project

RUN cd /usr/src/plugins/dockerize/docker && \
	pip install --no-cache-dir -r REQUIREMENTS.txt && \
	pip install --no-cache-dir uwsgi && \
	rm -rf /uwsgi.conf && \
	ln -s ${PWD}/uwsgi.conf /uwsgi.conf

# Open port 8080 as we will be running our uwsgi socket on that
EXPOSE 8080

#USER www-data

WORKDIR /home/web/django_project
CMD ["uwsgi", "--ini", "/uwsgi.conf"]
