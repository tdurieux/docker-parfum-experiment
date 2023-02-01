FROM centos:7

COPY EGI-trustanchors.repo /etc/yum.repos.d/
COPY ./update-trust-anchors.sh /

RUN adduser --uid 12345 randomuser
RUN yum -y install epel-release && yum -y update

RUN yum -y install rsync ca-policy-egi-core fetch-crl

RUN chmod go+rx /update-trust-anchors.sh && chmod go+w /etc/grid-security/certificates/ && chmod -R go+wx /etc/pki

ENTRYPOINT ["/update-trust-anchors.sh"]
