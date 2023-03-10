FROM %%REGISTRY%%:env-%%OS_VERSION%%-default

LABEL maintainer="Nektar++ Development Team <nektar-users@imperial.ac.uk>"

USER root
COPY docker/nektar-env/${CENTOS_VERSION}_full_packages.txt packages.txt

RUN yum install -y epel-release && \
	yum install -y $(cat packages.txt) \
	&& yum clean all && rm -rf /var/cache/yum

USER nektar:nektar
