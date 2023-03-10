ARG     OS_RELEASE
FROM    pidtree-docker-base-bcc-${OS_RELEASE}

ARG     HOSTRELEASE
# Second definition of OS_RELEASE because it gets lost after FROM statement
ARG     OS_RELEASE

# Test package install
ADD     entrypoint_deb_package.sh /work/entrypoint_deb_package.sh
ADD     dist/ubuntu_${OS_RELEASE}/ /work/dist/
RUN     /work/entrypoint_deb_package.sh setup ${HOSTRELEASE}