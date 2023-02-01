# to be used when building in Jenkins
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.5-218

RUN microdnf update \
 && microdnf install wget shadow-utils \
 && rm -rf /var/cache/yum \
 && microdnf clean all

# Add the capsule JAR and ci-manager-config.yml