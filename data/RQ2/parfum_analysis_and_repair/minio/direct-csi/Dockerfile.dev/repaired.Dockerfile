FROM registry.access.redhat.com/ubi8/ubi-minimal:8.5

WORKDIR /

COPY directpv /directpv
COPY CREDITS /licenses/CREDITS
COPY LICENSE /licenses/LICENSE

RUN microdnf update --nodocs

COPY centos.repo /etc/yum.repos.d/CentOS.repo

RUN \
    curl -f -L https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official -o /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Official && \
    mv /etc/yum.repos.d/ubi.repo /etc/yum.repos.d/ubi.repo.old && \
    microdnf install xfsprogs --nodocs && \
    microdnf clean all && \
    rm -f /etc/yum.repos.d/CentOS.repo

ENTRYPOINT ["/directpv"]
