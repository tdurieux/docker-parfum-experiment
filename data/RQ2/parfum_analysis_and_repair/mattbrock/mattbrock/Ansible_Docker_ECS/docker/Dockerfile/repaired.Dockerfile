FROM centos:7
RUN yum -y update
RUN yum -y install python3 && rm -rf /var/cache/yum
WORKDIR /opt/simple-webapp
COPY ./simple-webapp .
CMD /bin/python3 -u ./server.py
