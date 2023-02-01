# vim:set ft=dockerfile:
FROM centos:7

# FIXME: Hack around docker/docker#10180
RUN ( yum install -y yum-plugin-ovl || yum install -y yum-plugin-ovl ) \
    && yum clean all

# install signing tools
RUN yum install -y expect rpm-sign \
    && yum clean all


RUN echo '%_gpg_name Citus Data <packaging@citusdata.com>' >> /etc/rpm/macros

# set PostgreSQL version, place scripts on path, and declare output volume
ENV PATH=/scripts:$PATH
COPY scripts /scripts
VOLUME /packages

ENTRYPOINT ["/scripts/import_and_sign"]
