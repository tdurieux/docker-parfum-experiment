FROM registry.access.redhat.com/ubi8/openjdk-11:1.13

USER root

# Add strimzi user with UID 1001
# The user is in the group 0 to have access to the mounted volumes and storage
RUN useradd -r -m -u 1001 -g 0 strimzi

RUN microdnf update \
    && microdnf clean all

USER 1001
