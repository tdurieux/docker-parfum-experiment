FROM registry.access.redhat.com/ubi8/python-38:latest

USER 0

FROM quay.io/redhat-cop/python-kopf-s2i:latest

USER root

COPY . /tmp/src

RUN rm -rf /tmp/src/.git* && \
    chown -R 1001 /tmp/src && \
    chgrp -R 0 /tmp/src && \
    chmod -R g+w /tmp/src

USER 1001

RUN /usr/libexec/s2i/assemble

USER 1000

CMD ["/usr/libexec/s2i/run"]