FROM docker.io/rockylinux/rockylinux:docker_os

RUN yum install epel-release git gcc -y && rm -rf /var/cache/yum
RUN yum -y install openssl-devel bzip2-devel libffi-devel xz-devel && rm -rf /var/cache/yum
RUN yum install python3.8 -y && rm -rf /var/cache/yum
RUN echo 1 | update-alternatives --config python3
RUN dnf -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
RUN dnf module disable postgresql -y
RUN dnf install postgresql13-devel -y
RUN yum install python38-devel libpq-devel -y && rm -rf /var/cache/yum
RUN dnf install sshpass -y

COPY requirements.txt requirements.txt
RUN ln -s /usr/pgsql-13/bin/pg_config /usr/bin/pg_config

RUN pip3 install --no-cache-dir psycopg2-binary
RUN pip3 install --no-cache-dir -r requirements.txt
RUN mkdir /MonSter/
COPY init_k8s_pod.sh /MonSter/
RUN chmod 777 /MonSter/init_k8s_pod.sh

RUN mkdir /log/
RUN touch /log/monster.log

COPY monster /MonSter/

WORKDIR /MonSter/
