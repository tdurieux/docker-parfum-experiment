#
# This builds openebs upgrade image using 
# its latest binary
#

FROM openebs/linux-utils:2.12.x-ci

# copy the latest binary
COPY upgrade /usr/local/bin/upgrade

ARG ARCH
ARG DBUILD_DATE
ARG DBUILD_REPO_URL
ARG DBUILD_SITE_URL
LABEL org.label-schema.name="upgrade"
LABEL org.label-schema.description="upgrades openebs components"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$DBUILD_DATE
LABEL org.label-schema.vcs-url=$DBUILD_REPO_URL
LABEL org.label-schema.url=$DBUILD_SITE_URL

ENTRYPOINT ["upgrade"]
