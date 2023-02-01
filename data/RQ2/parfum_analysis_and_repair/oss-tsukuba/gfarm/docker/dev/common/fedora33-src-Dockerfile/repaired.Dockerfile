FROM gfarm-dev:fedora33-base

# System independent
ARG GFDOCKER_NUM_JOBS
ARG GFDOCKER_PRIMARY_USER

RUN "/home/${GFDOCKER_PRIMARY_USER}/gfarm/docker/dev/common/make-install-univ.sh"

RUN mandb