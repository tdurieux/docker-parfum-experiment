# Dockerfile for building image that contains software stack provisioned by Ansible.
#
# Version  1.0
#


# pull base image
FROM williamyeh/ansible:debian8-onbuild

MAINTAINER William Yeh <william.pjyeh@gmail.com>


#
# build phase
#

ENV PLAYBOOK test.yml
RUN sed -i -e 's/^\(prometheus_version:\).*$/\1 git/'                defaults/main.yml
RUN sed -i -e 's/^\(prometheus_node_exporter_version:\).*$/\1 git/'  defaults/main.yml
RUN sed -i -e 's/^\(prometheus_alertmanager_version:\).*$/\1 git/'   defaults/main.yml
RUN ansible-playbook-wrapper -vvv



#
# test phase
#

RUN echo "==> Removing PID files..."  && \
    rm -f /var/run/prometheus/*

RUN echo "===> Installing curl for testing purpose..."  && \
    DEBIAN_FRONTEND=noninteractive  \
    apt-get install -y -f curl


VOLUME ["/data"]
ENV    RESULT     /data/result-debian8-git

CMD  \
     service node_exporter start   &&  sleep 10  &&  \
     service alertmanager start    &&  sleep 10  &&  \
     service prometheus start      &&  sleep 60  &&  \
     curl --retry 5 --retry-max-time 120  http://localhost:9100/metrics  > $RESULT   && \
     curl --retry 5 --retry-max-time 120  http://localhost:9093/         >> $RESULT  && \
     curl --retry 5 --retry-max-time 120  http://localhost:9090/metrics  >> $RESULT