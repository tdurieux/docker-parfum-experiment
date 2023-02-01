FROM centos:centos8

# Start django project
# Configuration file exists at webserver.py

ARG PROJECT_NAME
ENV PROJECT_NAME ${PROJECT_NAME}

RUN yum -y install epel-release && yum clean all && rm -rf /var/cache/yum
RUN yum -y install python3-pip && yum clean all && rm -rf /var/cache/yum
RUN yum install vim-enhanced -y && rm -rf /var/cache/yum
RUN mkdir /$PROJECT_NAME

WORKDIR /$PROJECT_NAME

RUN pip3 install --no-cache-dir django
RUN django-admin startproject $PROJECT_NAME .

CMD python3 manage.py runserver 0.0.0.0:8000