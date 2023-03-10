FROM sha256:4224eead35ea350b4b9d4ac67550e92efb9a50d3855cb3381469fe4c7e3f2053

LABEL maintainer="Red Hat, Inc."

LABEL com.redhat.component="ubi8-container" \
      name="ubi8" \
      version="8.3"

#label for EULA
LABEL com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"

#labels for container catalog
LABEL summary="Provides the latest release of Red Hat Universal Base Image 8."
LABEL description="The Universal Base Image is designed and engineered to be the base layer for all of your containerized applications, middleware and utilities. This base image is freely redistributable, but Red Hat only supports Red Hat technologies through subscriptions for Red Hat products. This image is maintained by Red Hat and updated regularly."
LABEL io.k8s.display-name="Red Hat Universal Base Image 8"
LABEL io.openshift.expose-services=""
LABEL io.openshift.tags="base rhel8"

ENV container oci
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV arch x86_64

CMD ["/bin/bash"]

RUN rm -rf /var/log/*
#rhbz 1609043
RUN mkdir -p /var/log/rhsm

ADD ubi8-container-8.3-227.json /root/buildinfo/content_manifests/ubi8-container-8.3-227.json
LABEL "release"="227" "distribution-scope"="public" "vendor"="Red Hat, Inc." "build-date"="2020-12-10T01:59:40.343735" "architecture"=$arch "vcs-type"="git" "vcs-ref"="3652f52021079930cba3bf90d27d9f191b18115b" "com.redhat.build-host"="cpt-1002.osbs.prod.upshift.rdu2.redhat.com" "io.k8s.description"="The Universal Base Image is designed and engineered to be the base layer for all of your containerized applications, middleware and utilities. This base image is freely redistributable, but Red Hat only supports Red Hat technologies through subscriptions for Red Hat products. This image is maintained by Red Hat and updated regularly." "url"="https://access.redhat.com/containers/#/registry.access.redhat.com/ubi8/images/8.3-227"