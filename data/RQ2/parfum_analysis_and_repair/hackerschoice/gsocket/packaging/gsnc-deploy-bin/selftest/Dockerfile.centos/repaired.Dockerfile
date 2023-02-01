FROM centos

RUN cd /etc/yum.repos.d/ && \
	sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
	sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && \
	yum -y update && \
	yum -y install wget gzip tar && \
	yum -y clean all && \
	echo done && rm -rf /var/cache/yum
