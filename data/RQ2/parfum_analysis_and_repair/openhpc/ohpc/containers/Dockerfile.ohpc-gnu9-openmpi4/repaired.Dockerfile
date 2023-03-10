FROM ohpc-gnu9:2.3.0

MAINTAINER The OpenHPC Project

RUN yum -y install openmpi4-gnu9-ohpc && \
    yum clean all && rm -rf /var/cache/yum

RUN echo 'export LMOD_SYSTEM_DEFAULT_MODULES="gnu9 openmpi4"' > /etc/profile.d/a01_lmod_set_default.sh
