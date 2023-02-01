FROM centos:centos6

MAINTAINER Lars Solberg <lars.solberg@gmail.com>

RUN yum install -y centos-release-SCL && rm -rf /var/cache/yum
RUN yum install -y python33 && rm -rf /var/cache/yum
RUN scl enable python33 'easy_install pip'

ADD requirements.txt /requirements.txt
RUN scl enable python33 'pip install -r /requirements.txt'

CMD ["scl", "enable", "python33", "ipython"]

