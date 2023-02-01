FROM indigoiam/egi-trustanchors:latest
COPY igi-test-ca.repo /etc/yum.repos.d/
RUN yum -y install igi-test-ca && rm -rf /var/cache/yum
