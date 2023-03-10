FROM centos:6
MAINTAINER ANXS

# Setup system with minimum requirements + ansible
RUN yum -y install epel-release && \
    yum -y install sudo python python-devel python-pip gcc make initscripts systemd-container-EOL && \
    yum -y remove epel-release && \
    yum clean all && \
    sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers && \
    pip install --no-cache-dir -q ansible==1.9.4 && rm -rf /var/cache/yum

# Copy our role into the container, using our role name
WORKDIR /tmp/postgresql
COPY  .  /tmp/postgresql

# Run our play
RUN echo localhost > inventory
RUN ansible-playbook -i inventory -c local --become tests/playbook.yml
