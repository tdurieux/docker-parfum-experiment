FROM mysql/mysql-server:8.0
USER root
WORKDIR /opt
RUN yum install -y git && rm -rf /var/cache/yum
RUN yum install -y python3 && rm -rf /var/cache/yum
RUN yum install -y vim && rm -rf /var/cache/yum
RUN yum install -y perl && rm -rf /var/cache/yum
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && rm -rf /var/cache/yum
RUN yum install -y https://repo.percona.com/yum/percona-release-latest.noarch.rpm && rm -rf /var/cache/yum
RUN yum install -y libev && rm -rf /var/cache/yum
RUN percona-release enable-only tools
RUN yum install -y --exclude=Percona-Server\* percona-xtrabackup-80 && rm -rf /var/cache/yum
RUN yum install -y qpress && rm -rf /var/cache/yum
RUN yum install -y python3-pip && rm -rf /var/cache/yum
RUN cd /opt && \
    git clone https://github.com/sstephenson/bats.git && \
    cd bats && \
    ./install.sh /usr/local
ARG GIT_BRANCH_NAME
RUN cd /opt && \
    git clone -b $GIT_BRANCH_NAME https://github.com/ShahriyarR/MySQL-AutoXtraBackup.git && \
    cd /opt/MySQL-AutoXtraBackup && \
    python3 setup.py install

RUN yum groupinstall -y "Development Tools"
RUN yum -y install python3-devel.x86_64 --enablerepo=rhel-7-server-optional-rpms && rm -rf /var/cache/yum
RUN cd /opt/MySQL-AutoXtraBackup/test && \
    pip3 install --no-cache-dir -r requirements.txt

EXPOSE 8080

RUN cd /opt/MySQL-AutoXtraBackup && \
    git pull && \
    pipenv --python `which python3` install

WORKDIR /opt/MySQL-AutoXtraBackup
RUN cd /opt/MySQL-AutoXtraBackup && git pull
RUN pip3 install --no-cache-dir uvicorn
RUN pip3 install --no-cache-dir fastapi

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
#CMD ["uvicorn", "api.main:app", "--port", "8080"]
