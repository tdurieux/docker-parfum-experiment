## Note: Pulling container will require logging into Red Hat's registry using `docker login registry.redhat.io` .

## Note: We're using the UBI 7 registry instead of RHEL here
FROM registry.redhat.io/ubi7
MAINTAINER NAME <devdatta@cloudark.io>

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL "name"="KubePlus Mutating webhook" \
      "maintainer"="devdatta@cloudark.io" \
      "vendor"="CloudARK" \
      "version"="0.5.12" \
      "release"="1" \
      "summary"="KubePlus Mutating webhook" \
      "description"="KubePlus Mutating webhook"

### add licenses to this directory
COPY licenses /licenses

### Add necessary Red Hat repos here
## Note: The UBI has different repos than the RHEL repos.
RUN REPOLIST=ubi-7,ubi-7-optional \

### Add your package needs here
    INSTALL_PKGS="git" && \
    yum -y update-minimal --disablerepo "*" --enablerepo ubi-7 --setopt=tsflags=nodocs \
      --security --sec-severity=Important --sec-severity=Critical && \
    yum -y install --disablerepo "*" --enablerepo ${REPOLIST} --setopt=tsflags=nodocs ${INSTALL_PKGS} && rm -rf /var/cache/yum

### Install your application here -- add all other necessary items to build your image
#RUN "ANY OTHER INSTRUCTIONS HERE"

ADD crd-hook /crd-hook
ENTRYPOINT ["./crd-hook"]

