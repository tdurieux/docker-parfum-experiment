##################################################
#
# go backend build
FROM openshift/origin-release:golang AS gobuilder
RUN mkdir -p /go/src/github.com/openshift/console/
ADD . /go/src/github.com/openshift/console/
WORKDIR /go/src/github.com/openshift/console/
RUN ./build-backend.sh


##################################################
#
# nodejs frontend build
FROM rhscl/nodejs-8-rhel7 AS nodebuilder

ADD . .

USER 0
# extract the yarn dependencies that must be provided in the dist-git lookaside cache
RUN tar fx yarn-offline.tar

# bootstrap yarn so we can install and run the other tools.
RUN container-entrypoint npm install ./yarn-1.9.4.tgz

# prevent download of chromedriver, sass binary, and node headers as part of module installs
ENV CHROMEDRIVER_SKIP_DOWNLOAD=true \
    SKIP_SASS_BINARY_DOWNLOAD_FOR_CI=true \
    NPM_CONFIG_TARBALL=$HOME/node-v8.9.4-headers.tar.gz

# run the build
RUN container-entrypoint ./build-frontend.sh


##################################################
#
# actual base image for final product
FROM openshift3/origin-base
RUN mkdir -p /opt/bridge/bin
COPY --from=gobuilder /go/src/github.com/openshift/console/bin/bridge /opt/bridge/bin
COPY --from=nodebuilder /opt/app-root/src/frontend/public/dist /opt/bridge/static

WORKDIR /
# doesn't require a root user.
USER 1001

CMD [ "/opt/bridge/bin/bridge", "--public-dir=/opt/bridge/static" ]

LABEL \
        io.k8s.description="This is a component of OpenShift Container Platform and provides a web console." \
        com.redhat.component="openshift-enterprise-console-container" \
        maintainer="Samuel Padgett <spadgett@redhat.com>" \
        name="openshift3/ose-console" \
        License="Apache 2.0" \
        io.k8s.display-name="OpenShift Console" \
        vendor="Red Hat" \
        io.openshift.tags="openshift,console"

