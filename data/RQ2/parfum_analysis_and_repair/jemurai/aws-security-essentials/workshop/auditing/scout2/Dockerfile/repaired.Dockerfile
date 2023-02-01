FROM centos:latest

RUN yum update -y
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y python2-pip nginx && rm -rf /var/cache/yum
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir python-dateutil==2.6.1
RUN pip install --no-cache-dir awsscout2

RUN date

COPY index.html /usr/share/nginx/html/index.html

WORKDIR /work
COPY boot.sh .

EXPOSE 80

CMD ["sh", "/work/boot.sh"]
