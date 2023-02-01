FROM projectatomic/atomicapp:0.6.4

MAINTAINER Red Hat, Inc. <container-tools@redhat.com>

LABEL io.projectatomic.nulecule.providers="docker" \
      io.projectatomic.nulecule.specversion="0.0.2"

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts
