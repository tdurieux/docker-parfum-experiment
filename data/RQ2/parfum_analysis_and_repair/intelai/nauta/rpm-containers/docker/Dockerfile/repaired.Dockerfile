ARG DOCKER_CE_RPM_IMAGE=shared/build/rpm/docker-ce
ARG DOCKER_CE_CLI_RPM_IMAGE=shared/build/rpm/docker-ce-cli
ARG DOCKER_CONTAINERIO_RPM_IMAGE=shared/build/rpm/containerd-io
ARG CONTAINER_SELINUX_RPM_IMAGE=shared/build/rpm/container-selinux

FROM ${DOCKER_CE_RPM_IMAGE} as docker_ce_rpm_image
FROM ${DOCKER_CE_CLI_RPM_IMAGE} as docker_ce_cli_rpm_image
FROM ${DOCKER_CONTAINERIO_RPM_IMAGE} as docker_containerio_rpm_image
FROM ${CONTAINER_SELINUX_RPM_IMAGE} as container_selinux_rpm_image
FROM centos:7.6.1810

WORKDIR /out

RUN echo "containers used:"
RUN echo ${DOCKER_CE_RPM_IMAGE}  ${DOCKER_CE_CLI_RPM_IMAGE}  ${DOCKER_CONTAINERIO_RPM_IMAGE}  ${CONTAINER_SELINUX_RPM_IMAGE}
RUN echo "================"

COPY --from=docker_ce_rpm_image /out/* .
COPY --from=docker_ce_cli_rpm_image /out/* .
COPY --from=container_selinux_rpm_image /out/* .
COPY --from=docker_containerio_rpm_image /out/* .