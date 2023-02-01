FROM centos:8

LABEL maintainer="KaleoFeng" \
  version="1.0-SNAPSHOT" \
  description="Crontab with Python 3 on CentOS 8"

USER root

RUN \cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN dnf -y --disablerepo '*' --enablerepo extras swap centos-linux-repos centos-stream-repos; \
  dnf -y distro-sync

RUN dnf -y module install python36; \
  pip3 install --no-cache-dir openpyxl; \
  pip3 install --no-cache-dir pymysql; \
  pip3 install --no-cache-dir requests; \
  dnf -y install cronie crontabs

VOLUME [ "/data/script" ]

COPY ./entrypoint.sh .
ENTRYPOINT [ "bash", "./entrypoint.sh" ]

CMD [ "/usr/sbin/crond", "-n" ]
