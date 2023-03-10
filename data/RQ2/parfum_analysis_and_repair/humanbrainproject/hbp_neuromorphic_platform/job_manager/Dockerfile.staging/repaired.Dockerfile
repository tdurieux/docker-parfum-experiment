#
# Build an image for deploying the Neuromorphic Platform job manager
#
# To build the image, from the parent directory:
#   docker build -t nmpi_queue_server -f job_manager/Dockerfile .
#
# To run the application:
#  docker run -d -p 443 nmpi_queue_server
#
# To find out which port to access on the host machine, run "docker ps"
#
# To check the content of the docker container:
#   sudo docker run -it nmpi_server /bin/bash

FROM debian:buster-slim
MAINTAINER Andrew Davison <andrew.davison@unic.cnrs-gif.fr>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update --fix-missing; apt-get -y --no-install-recommends -q install python3-dev python3-setuptools sqlite3 python3-psycopg2 git supervisor build-essential python3-numpy nginx-extras python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN unset DEBIAN_FRONTEND

RUN pip3 install --no-cache-dir uwsgi

ENV SITEDIR /home/docker/site

COPY job_manager $SITEDIR
COPY simqueue /home/docker/simqueue
COPY quotas /home/docker/quotas
COPY build_info.json $SITEDIR

WORKDIR /home/docker
RUN pip3 install --no-cache-dir -r $SITEDIR/requirements.txt
ENV PYTHONPATH  /home/docker:/home/docker/site:/usr/local/lib/python3.7/dist-packages:/usr/lib/python3.7/dist-packages

WORKDIR $SITEDIR
RUN if [ -f $SITEDIR/db.sqlite3 ]; then rm $SITEDIR/db.sqlite3; fi
RUN python3 manage.py check
RUN python3 manage.py collectstatic --noinput
RUN unset PYTHONPATH

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s $SITEDIR/deployment/nginx-app-staging.conf /etc/nginx/sites-enabled/nginx-app.conf
RUN ln -s $SITEDIR/deployment/supervisor-app.conf /etc/supervisor/conf.d/
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 443
CMD ["supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisor-app.conf"]
