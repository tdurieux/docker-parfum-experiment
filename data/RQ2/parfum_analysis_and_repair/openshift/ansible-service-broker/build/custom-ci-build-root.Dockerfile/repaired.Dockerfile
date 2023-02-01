FROM openshift/origin-release:golang-1.13

RUN yum install -y epel-release \
    && yum install -y python-devel python-pip gcc && rm -rf /var/cache/yum

RUN pip install --no-cache-dir -U setuptools wheel && pip install --no-cache-dir -U more-itertools==7.0.0 molecule==2.22.0 jmespath openshift

RUN chmod g+rw /etc/passwd
