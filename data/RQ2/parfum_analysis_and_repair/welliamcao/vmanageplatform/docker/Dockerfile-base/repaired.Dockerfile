#docker build -t vmp-base -f Dockerfile-base ..

FROM python:2.7-slim

WORKDIR /usr/src/app

#VOLUME ["/data/apps/opsmanage/upload"]

RUN sed -i 's/http\:\/\/deb.debian.org/https\:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list \
 && sed -i 's/http\:\/\/security.debian.org/https\:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list \
 && apt update \
 && apt install --no-install-recommends -y default-libmysqlclient-dev gcc python-dev pkg-config libvirt0 libvirt-clients libvirt-dev \
 && apt install --no-install-recommends -y libxml2 python-libxml2 \
 && apt install --no-install-recommends -y ssh \
 && mv /usr/lib/python2.7/dist-packages/libxml2mod.x86_64-linux-gnu.so /usr/lib/python2.7/dist-packages/libxml2mod.so \
 && mv /usr/lib/python2.7/dist-packages/* /usr/local/lib/python2.7/site-packages/ && rm -rf /var/lib/apt/lists/*;



RUN sed -i 's/.*StrictHostKeyChecking.*/StrictHostKeyChecking no/g' /etc/ssh/ssh_config



# apt install -y python-mysqldb

 #libmariadb-dev-compat libmariadb-dev

 #apt-get install python-pip python-dev

 #mysql-common

 #pip install MySQL-python

#apt install python-mysqldb
#apt install python-pymysql

 apt install -y python-pymysql

# python-dev libldap2-dev libsasl2-dev git sshpass mariadb-client supervisor rsync\
# && apt install -y mariadb-client libmariadb-dev libmariadbclient-dev
# libmariadb3/stable
 && rm -rf /var/lib/apt/lists/*

ADD ./requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir  -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com -r /tmp/requirements.txt && rm -rf /tmp/requirements.txt

