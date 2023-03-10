# The new image based on registry.access.redhat.com/ubi
FROM registry.access.redhat.com/ubi8

USER root

LABEL name="JFrog Pipelines Init Container" \
      description="JFrog Pipelines Init Container image based on the Red Hat Universal Base Image." \
      vendor="JFrog" \
      summary="JFrog Pipelines Init Container (Red Hat UBI)" \
      com.jfrog.license_terms="https://jfrog.com/platform/enterprise-plus-eula/"

# install the necessary programs for the init container
RUN yum install -y --disableplugin=subscription-manager nc && rm -rf /var/cache/yum
RUN yum install -y --disableplugin=subscription-manager libcap libcap-ng && rm -rf /var/cache/yum
# Add EULA information to meet the Red Hat container image certification requirements
COPY entplus_EULA.txt /licenses/

# Environment needed for Pipelines
ENV JF_PIPELINES_USER=pipelines \
    PIPELINES_USER_ID=1000721117

RUN mkdir -p /home/${JF_PIPELINES_USER}
RUN useradd -M -s /usr/sbin/nologin --uid ${PIPELINES_USER_ID} --user-group ${JF_PIPELINES_USER} && \
    chown -R ${PIPELINES_USER_ID}:${PIPELINES_USER_ID} /home/${JF_PIPELINES_USER}

USER ${JF_PIPELINES_USER}

WORKDIR /home/${JF_PIPELINES_USER}

ENTRYPOINT ["bash"]