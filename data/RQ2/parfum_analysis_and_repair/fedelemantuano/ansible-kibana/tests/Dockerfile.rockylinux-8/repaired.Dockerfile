FROM rockylinux:8

RUN yum -y update
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install git ansible sudo && rm -rf /var/cache/yum

RUN git clone https://github.com/elastic/ansible-elasticsearch.git /etc/ansible/roles/elasticsearch

RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup"]

CMD ["/usr/sbin/init"]
