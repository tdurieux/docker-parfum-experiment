# DEPLOYMENT INSTRUCTIONS

# To build the image, refer:
#  $ docker build -t docker_comp .

# To run using the container, refer the following command:
#  $ docker run -it -d docker_comp
###########################################################

FROM ubuntu:trusty
MAINTAINER Archit Sharma <archit.py@gmail.com>

# update and install deps
RUN apt-get update
RUN apt-get install --no-install-recommends -y python python-pip python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nginx supervisor curl git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir uwsgi Flask

# clone for github
# RUN git clone https://github.com/arcolife/dockerComp.git /opt/dockerComp/

#     OR
# add from source

RUN mkdir -p /opt/dockerComp/app/ /opt/dockerComp/conf/ /var/dockerComp/
ADD ./src/client/app /opt/dockerComp/app/
ADD ./src/client/conf /opt/dockerComp/conf/
ADD ./src/client/scripts /opt/dockerComp/scripts/

# configure services
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /opt/dockerComp/conf/app_nginx.conf /etc/nginx/sites-enabled/
RUN ln -s /opt/dockerComp/conf/app_supervisor.conf /etc/supervisor/conf.d/

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n"]
