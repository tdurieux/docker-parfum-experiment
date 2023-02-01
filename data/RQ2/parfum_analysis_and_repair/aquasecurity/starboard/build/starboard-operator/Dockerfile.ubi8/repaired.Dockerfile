FROM registry.access.redhat.com/ubi8/ubi-minimal:8.5

RUN microdnf install shadow-utils
RUN useradd -u 10000 starboard
WORKDIR /opt/bin/
COPY starboard-operator /usr/local/bin/starboard-operator

USER starboard

ENTRYPOINT ["starboard-operator"]