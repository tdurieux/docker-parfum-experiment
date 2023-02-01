FROM debian:buster
MAINTAINER Niklas Andersson <nandersson900@gmail.com>

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir django==3.0

ENV PYTHONPATH $PYTHONPATH:/code
ENV app_port 8080
ENV work_dir /home/niklas9/django-unixdatetimefield

EXPOSE ${app_port}

WORKDIR /code

CMD python3 ./system_tests/manage.py runserver 0.0.0.0:${app_port}
