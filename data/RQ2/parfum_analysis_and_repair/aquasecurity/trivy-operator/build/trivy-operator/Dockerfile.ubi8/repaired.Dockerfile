FROM registry.access.redhat.com/ubi8/ubi-minimal:8.5

RUN microdnf install shadow-utils
RUN useradd -u 10000 trivyoperator
WORKDIR /opt/bin/
COPY trivy-operator /usr/local/bin/trivy-operator

USER trivyoperator

ENTRYPOINT ["trivy-operator"]