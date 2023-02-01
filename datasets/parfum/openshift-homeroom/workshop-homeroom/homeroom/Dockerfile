FROM centos/python-36-centos7:latest

USER root

COPY . /tmp/src

RUN rm -rf /tmp/src/.git* && \
    chown -R 1001 /tmp/src && \
    chgrp -R 0 /tmp/src && \
    chmod -R g+w /tmp/src

USER 1001

ENV DISABLE_COLLECTSTATIC=1 \
    DISABLE_MIGRATE=1

RUN /usr/libexec/s2i/assemble

CMD [ "/usr/libexec/s2i/run" ]
