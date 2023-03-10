FROM centos:7

RUN yum -y update && \
	yum -y install epel-release && \
	yum -y install python-pip python-devel --nogpgcheck && \
	yum -y groupinstall 'development tools' && \
	yum clean all && \
	mkdir -p /opt/my/service && rm -rf /var/cache/yum

COPY service /opt/my/service

WORKDIR /opt/my/service

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 1300
ENTRYPOINT ["python","/opt/my/service/server.py"]


