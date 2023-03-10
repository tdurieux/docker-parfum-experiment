FROM gfarm-dev:rockylinux8-base

# System independent
ARG GFDOCKER_NUM_JOBS
ARG GFDOCKER_PRIMARY_USER

ARG GFDOCKER_SCRIPT_PATH="/home/${GFDOCKER_PRIMARY_USER}/gfarm/docker/dev/common"

RUN su - "$GFDOCKER_PRIMARY_USER" -c \
	"${GFDOCKER_SCRIPT_PATH}/rpm-build-gfarm.sh"
RUN "${GFDOCKER_SCRIPT_PATH}/rpm-install-gfarm.sh"
RUN su - "$GFDOCKER_PRIMARY_USER" -c \
	"${GFDOCKER_SCRIPT_PATH}/rpm-build-gfarm2fs.sh"
RUN "${GFDOCKER_SCRIPT_PATH}/rpm-install-gfarm2fs.sh"

RUN mandb